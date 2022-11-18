class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.28.1/deno_src.tar.gz"
  sha256 "1f5c0ee6c805508316f065f1540ca95f887d040d531c4bba688c656bd3bd6abd"
  license "MIT"
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c440709f3c530b2a201b34796ee87c3ed6f291f4ab69ce664f96571dd417f86a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c88674b3e2334133047ecb07671d3e3ff839a74f9832a4b51296af3a695bbde6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4752ed8245633fef9eada9a8d36e43bb5c214e30eacbef75c7c13de13b9c6ae4"
    sha256 cellar: :any_skip_relocation, ventura:        "7b577a80edf86611323cdcea4388c5a9e6ffa271f4496c0dd807e7dd4b7e008a"
    sha256 cellar: :any_skip_relocation, monterey:       "eb3e4f612bd1e185ef68365881f3f283222c773a540713f816bc0a50926b1078"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc21fa1063402004bdcef56a3055a66a349247f3cf8c7c57e709f24afd79258b"
    sha256 cellar: :any_skip_relocation, catalina:       "8d0593336d812cbfa97d512b6dd23ed62ad850135a5527707ed5fa838e416357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e953dc1fcdd3a20bd0f40d3daf1921f0a3408ec652b7198673f242a499e0a53"
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
