class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://nubjs.com"
  url "https://github.com/nubjs/nub/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "720c7e73bf1d4aad7a1eb112c9b89022bdd48e6febe9a2100d7159ac9eadd273"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    manifest_sha256 "57ba2d72968104001e63d79c7e4e79b1f425df8d9114858d8e5155e4b70f38eb"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0662a92d1bd7fb1e8f51abe0c1d4c941c4641e1c58e6151bb2e505e9be65c6ab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "95c04447a5da14360dcbed94d256ac4d0a7f5a2b38ea6607388c22d1f1adb446"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4cfcc8de8901e4c66b9339ae3cb34b3b378f3545c3adae177122d17ecfb797dc"
    sha256 cellar: :any,                 arm64_linux:       "90562ce2b836c12773a580a409082ab6796c8c99e19424819d08d3e171f892f2"
    sha256 cellar: :any,                 x86_64_linux:      "4f2c616f47cd717ec59dee9c7440aa2d038de67f3f7ef94d1059c154c4ce9b29"
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
