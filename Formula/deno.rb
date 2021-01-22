class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.7.0/deno_src.tar.gz"
  sha256 "f215103d0bea381495008a8f9e90c467248a2a14d3357c6d105c084186423072"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "f57ffbf236768e798bda681cf9d6809752fb53763469c37164ab7e5bf71d98ef" => :big_sur
    sha256 "6a100d4b0384eae1eec6bb8bd52587b99633d13a07ad8811759216aef45366db" => :catalina
    sha256 "1bb8ada642868d8741e44316c3b7d69b6a2bd1741d4653d5b19f6c6749e5c07e" => :mojave
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
    # env args for building a release build with our clang, ninja and gn
    ENV["GN"] = buildpath/"gn/out/gn"
    ENV["NINJA"] = Formula["ninja"].opt_bin/"ninja"
    ENV["SCCACHE"] = Formula["sccache"].opt_bin/"sccache"
    # build rusty_v8 from source
    ENV["V8_FROM_SOURCE"] = "1"
    # Build with llvm. We don't remove llvm from HOMEBREW_LIBRARY_PATHS
    # as this causes build failures. This does not create runtime dependencies.
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
