class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.12.2/deno_src.tar.gz"
  sha256 "4ac5a1a29d8490220c5c35eb6eb35675eb01abf3022a1fb88e4620d7ba481734"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9c3ef21ec938fc371d1741b09bde3b677eb7efbc4a78004e548f14f8f0755706"
    sha256 cellar: :any_skip_relocation, big_sur:       "ab0a5268c2a5a1db9793945fb385b3ac5e761f86884c7e6a8f51db33d051239b"
    sha256 cellar: :any_skip_relocation, catalina:      "40d1387b00a257db172ea2fabdfe8ec1adeaa77b9da7914be9bf4b3a41890a6d"
    sha256 cellar: :any_skip_relocation, mojave:        "63f07564b8feeb57deb709092f940b436e995090e60a87d242a5afebe3efa7e0"
  end

  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "python@3.9" => :build
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

  # To find the version of gn used:
  # 1. Find rusty_v8 version: https://github.com/denoland/deno/blob/v#{version}/core/Cargo.toml
  # 2. Find ninja_gn_binaries tag: https://github.com/denoland/rusty_v8/tree/v#{rusty_v8_version}/tools/ninja_gn_binaries.py
  # 3. Find short gn commit hash from commit message: https://github.com/denoland/ninja_gn_binaries/tree/#{ninja_gn_binaries_tag}
  # 4. Find full gn commit hash: https://gn.googlesource.com/gn.git/+/#{gn_commit}
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "53d92014bf94c3893886470a1c7c1289f8818db0"
  end

  def install
    on_macos do
      # Overwrite Chromium minimum SDK version of 10.15
      ENV["FORCE_MAC_SDK_MIN"] = MacOS.version if MacOS.version < :mojave
    end

    # env args for building a release build with our python3, ninja and gn
    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"
    ENV["GN"] = buildpath/"gn/out/gn"
    ENV["NINJA"] = Formula["ninja"].opt_bin/"ninja"
    # build rusty_v8 from source
    ENV["V8_FROM_SOURCE"] = "1"
    # Build with llvm and link against system libc++ (no runtime dep)
    ENV["CLANG_BASE_PATH"] = Formula["llvm"].prefix
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    resource("gn").stage buildpath/"gn"
    cd "gn" do
      system "python3", "build/gen.py"
      system "ninja", "-C", "out"
    end

    cd "cli" do
      # cargo seems to build rusty_v8 twice in parallel, which causes problems,
      # hence the need for -j1
      system "cargo", "install", "-vv", "-j1", *std_cargo_args
    end

    bash_output = Utils.safe_popen_read(bin/"deno", "completions", "bash")
    (bash_completion/"deno").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"deno", "completions", "zsh")
    (zsh_completion/"_deno").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"deno", "completions", "fish")
    (fish_completion/"deno.fish").write fish_output
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
