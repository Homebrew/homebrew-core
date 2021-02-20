class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.7.2/deno_src.tar.gz"
  sha256 "a35b2cfef924fe0404eb901a3bfa0c4d50825db3c14e4da823963e645f96e83d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "576c6f82b80cb049a1c62ca24a9161abc10ca96d4fadd50f8dffc4522910bcb3"
    sha256 cellar: :any_skip_relocation, big_sur:       "3d0d729d1716936eb02be57732b05a2b2e8082cd7368dd3161784ed04e71023b"
    sha256 cellar: :any_skip_relocation, catalina:      "f08ceafe2bd055b4891651f17393c898602ca010dd08e62dbf3d5c547beeab55"
    sha256 cellar: :any_skip_relocation, mojave:        "310e78a9bf651cbb2443e099b1b25967d61373f2ac3e8dc951c2795c4975788d"
  end

  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "sccache" => :build
  depends_on xcode: ["10.0", :build] # required by v8 7.9+
  depends_on :macos # Due to Python 2 (see https://github.com/denoland/deno/issues/2893)

  uses_from_macos "xz"

  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "53d92014bf94c3893886470a1c7c1289f8818db0"
  end

  def install
    # Overwrite Chromium minimum SDK version of 10.15
    ENV["FORCE_MAC_SDK_MIN"] = MacOS.version if MacOS.version < :mojave

    # env args for building a release build with our clang, ninja and gn
    ENV["GN"] = buildpath/"gn/out/gn"
    ENV["NINJA"] = Formula["ninja"].opt_bin/"ninja"
    ENV["SCCACHE"] = Formula["sccache"].opt_bin/"sccache"
    # build rusty_v8 from source
    ENV["V8_FROM_SOURCE"] = "1"
    # Build with llvm. We don't remove llvm from HOMEBREW_LIBRARY_PATHS
    # as this causes build failures. This does not create a runtime dependency.
    ENV["CLANG_BASE_PATH"] = Formula["llvm"].prefix

    resource("gn").stage buildpath/"gn"
    cd "gn" do
      system "python", "build/gen.py"
      system "ninja", "-C", "out"
    end

    cd "cli" do
      system "cargo", "install", "-vv", *std_cargo_args
    end

    bash_output = Utils.safe_popen_read("#{bin}/deno", "completions", "bash")
    (bash_completion/"deno").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/deno", "completions", "zsh")
    (zsh_completion/"_deno").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/deno", "completions", "fish")
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
