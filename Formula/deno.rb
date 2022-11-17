class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.28.1/deno_src.tar.gz"
  sha256 "1f5c0ee6c805508316f065f1540ca95f887d040d531c4bba688c656bd3bd6abd"
  license "MIT"
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "575a0db2838f68337f0e79fd681111ba3df2be4d97c34aeba0c75d747e9b06ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac95cd93164838f3d0d4a1b36bca8f038541343bf14913a00db6df348e6c2931"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06a02957cd9017257008358d2d7fb0db8d3032571e05f4cf6e29495378c670f4"
    sha256 cellar: :any_skip_relocation, monterey:       "d477278d1e3179755590d878bb0bb94abe9e90b6cd947330f87e07a2c72e0156"
    sha256 cellar: :any_skip_relocation, big_sur:        "45182866a064b0956f836350ac061e8221a68e588714bf92a5d4809e37559a64"
    sha256 cellar: :any_skip_relocation, catalina:       "f325f801d83c92f4e8c79d5a1f944d3408cb01935b9e6f14d9e0b69c2c076948"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe882bf4be18ee240a44768080f1d94a6239174437e9ad6a588955bb9a5b5cd2"
  end

  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => :build
  depends_on "rust" => :build

  uses_from_macos "xz"

  on_macos do
    depends_on xcode: ["10.0", :build] # required by v8 7.9+
  end

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "glib"
  end

  fails_with gcc: "5"

  # Temporary resources to work around build failure due to files missing from crate
  # We use the crate as GitHub tarball lacks submodules and this allows us to avoid git overhead.
  # TODO: Remove this and `v8` resource when https://github.com/denoland/rusty_v8/pull/1063 is released
  resource "rusty-v8" do
    url "https://static.crates.io/crates/v8/v8-0.55.0.crate"
    sha256 "46cd4f562bce7520fbb511850c5488366264caf346be221cf7e908f51ac33dbc"
  end

  resource "v8" do
    url "https://github.com/denoland/v8/archive/675c4782cc883e54d8a79b15348d7f0085d4f940.tar.gz"
    sha256 "7dbc0bf4052f08a9e856ffb2fa40faead904333461406126d3a20f3df94fc484"
  end

  # To find the version of gn used:
  # 1. Find v8 version: https://github.com/denoland/deno/blob/v#{version}/core/Cargo.toml
  # 2. Find ninja_gn_binaries tag: https://github.com/denoland/rusty_v8/tree/v#{v8_version}/tools/ninja_gn_binaries.py
  # 3. Find short gn commit hash from commit message: https://github.com/denoland/ninja_gn_binaries/tree/#{ninja_gn_binaries_tag}
  # 4. Find full gn commit hash: https://gn.googlesource.com/gn.git/+/#{gn_commit}
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "bf4e17dc67b2a2007475415e3f9e1d1cf32f6e35"
  end

  def install
    # Work around files missing from crate
    # TODO: Remove this at the same time as `rusty-v8` + `v8` resources
    (buildpath/"v8").mkpath
    resource("rusty-v8").stage do |r|
      system "tar", "--strip-components", "1", "-xzvf", "v8-#{r.version}.crate", "-C", buildpath/"v8"
    end
    resource("v8").stage do
      cp_r "tools/builtins-pgo", buildpath/"v8/v8/tools/builtins-pgo"
    end
    inreplace %w[core/Cargo.toml serde_v8/Cargo.toml],
              /^v8 = { version = ("[\d.]+"),.*}$/,
              "v8 = { version = \\1, path = \"../v8\" }"

    if OS.mac? && (MacOS.version < :mojave)
      # Overwrite Chromium minimum SDK version of 10.15
      ENV["FORCE_MAC_SDK_MIN"] = MacOS.version
    end

    python3 = "python3.11"
    # env args for building a release build with our python3, ninja and gn
    ENV.prepend_path "PATH", Formula["python@3.11"].libexec/"bin"
    ENV["PYTHON"] = Formula["python@3.11"].opt_bin/python3
    ENV["GN"] = buildpath/"gn/out/gn"
    ENV["NINJA"] = Formula["ninja"].opt_bin/"ninja"
    # build rusty_v8 from source
    ENV["V8_FROM_SOURCE"] = "1"
    # Build with llvm and link against system libc++ (no runtime dep)
    ENV["CLANG_BASE_PATH"] = Formula["llvm"].prefix

    resource("gn").stage buildpath/"gn"
    cd "gn" do
      system python3, "build/gen.py"
      system "ninja", "-C", "out"
    end

    # cargo seems to build rusty_v8 twice in parallel, which causes problems,
    # hence the need for -j1
    # Issue ref: https://github.com/denoland/deno/issues/9244
    system "cargo", "install", "-vv", "-j1", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"deno", "completions")
  end

  test do
    (testpath/"hello.ts").write <<~EOS
      console.log("hello", "deno");
    EOS
    assert_match "hello deno", shell_output("#{bin}/deno run hello.ts")
    assert_match "console.log",
      shell_output("#{bin}/deno run --allow-read=#{testpath} https://deno.land/std@0.50.0/examples/cat.ts " \
                   "#{testpath}/hello.ts")
  end
end
