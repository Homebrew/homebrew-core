class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://nubjs.com"
  url "https://github.com/nubjs/nub/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "5891f1728ba91d260b1ad2fb6c73d0004157c0bda042eb2d1b9d1dc4ac688c13"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ad46b3ec9112432814b05a6dbe32025028e63e9f1b4c55e7b566934860bf9d5e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9683bd62d97b5dad41cfd343e7d1510fad4dc1978219ac813eb62fd45783fed7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "335ae3a75b7a20cb01ac79e493d3e398cfcff2b47d8aace0256e66ac03f1ee34"
    sha256 cellar: :any,                 arm64_linux:       "fab6897b9de6992591c20a0974c198f091855c04fce444315239c357ca95ec36"
    sha256 cellar: :any,                 x86_64_linux:      "f440eddbb3300755a06f62016e8acd877abf690aff7cc27b266a7418a7f1db57"
  end

  depends_on "cmake" => :build
  depends_on "node" => [:build, :test]
  depends_on "rust" => :build

  def install
    # `runtime` has no package.json, so npm resolves up to the repository root
    # either way. Install there, where package-lock.json pins the versions.
    system "npm", "install", *std_npm_args(prefix: false)

    # The `embed-runtime` feature tars `runtime` into the binary, and the tree that
    # binary extracts at runtime has no parent node_modules to resolve through. Copy
    # in the packages that tree loads: the transpile helpers and the web API
    # polyfills. Without them the build still succeeds, but the binary fails to run
    # any file that needs a helper and silently drops Temporal, URLPattern and
    # Float16Array on Node versions that lack them natively.
    %w[
      @js-temporal/polyfill
      @oxc-project/runtime
      @petamoriken/float16
      jsbi
      urlpattern-polyfill
    ].each do |dep|
      (buildpath/"runtime/node_modules"/dep).dirname.mkpath
      cp_r buildpath/"node_modules"/dep, buildpath/"runtime/node_modules"/dep
    end

    cd "crates/nub-native" do
      system "cargo", "build", "--release", "--lib"
    end
    mkdir_p "runtime/addons"
    cp shared_library("target/release/libnub_native"), "runtime/addons/nub-native.node"

    system "cargo", "install", *std_cargo_args(path: "crates/nub-cli", features: ["embed-runtime"])
    bin.install_symlink bin/"nub" => "nubx"
    bin.install_symlink bin/"nub" => "nubr"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nub --version")
    assert_match "Usage: nub nubx", shell_output("#{bin}/nubx --help")
    assert_equal version.to_s, shell_output("#{bin}/nubr --version").strip

    (testpath/"package.json").write <<~JSON
      {
        "name": "test-app",
        "version": "1.0.0"
      }
    JSON

    # Transpile a file that pulls a helper out of the vendored runtime node_modules.
    # Legacy decorators are down-levelled on every Node version, so this covers the
    # embedded runtime whichever Node is on PATH.
    (testpath/"tsconfig.json").write <<~JSON
      {"compilerOptions": {"experimentalDecorators": true, "emitDecoratorMetadata": true}}
    JSON
    (testpath/"decorated.ts").write <<~TYPESCRIPT
      function log(target: any, key: string, descriptor: PropertyDescriptor) { return descriptor; }
      class Greeter { @log greet(): string { return "hello nub"; } }
      console.log(new Greeter().greet());
    TYPESCRIPT
    assert_equal "hello nub", shell_output("#{bin}/nub decorated.ts").strip

    system bin/"nub", "config", "set", "registry", "https://registry.npmjs.org"
    assert_match "https://registry.npmjs.org", shell_output("#{bin}/nub config get registry")
  end
end
