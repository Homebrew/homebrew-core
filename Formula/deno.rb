class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.6.0/deno_src.tar.gz"
  sha256 "60491d842e04ce162face61bb8857bf18a41726afbcbcd9fa532055ace7431ae"
  license "MIT"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "f57ffbf236768e798bda681cf9d6809752fb53763469c37164ab7e5bf71d98ef" => :big_sur
    sha256 "6a100d4b0384eae1eec6bb8bd52587b99633d13a07ad8811759216aef45366db" => :catalina
    sha256 "1bb8ada642868d8741e44316c3b7d69b6a2bd1741d4653d5b19f6c6749e5c07e" => :mojave
  end

  depends_on "llvm" => :build
  depends_on "rust" => :build
  depends_on xcode: ["10.0", :build] # required by v8 7.9+
  depends_on :macos # Due to Python 2 (see https://github.com/denoland/deno/issues/2893)

  uses_from_macos "xz"

  # Remove at next version bump. Check that new release includes:
  # https://github.com/denoland/deno/pull/8718
  patch do
    url "https://github.com/denoland/deno/commit/cea42bec3272a8020f1d94afcf1a4cd7e3985553.patch?full_index=1"
    sha256 "640ece7aab8e7486ea0ec4bfd29ac7e980822a57d12123e802d022bdc7bbaed7"
  end

  def install
    # env args for building a release build with our clang, ninja and gn
    ENV["GN"] = buildpath/"gn/out/gn"
    # build rusty_v8 from source
    ENV["V8_FROM_SOURCE"] = "1"
    # overwrite Chromium minimum sdk version of 10.15
    ENV["FORCE_MAC_SDK_MIN"] = "10.13"
    # build with llvm and link against system libc++ (no runtime dep)
    ENV["CLANG_BASE_PATH"] = Formula["llvm"].prefix
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    cd "cli" do
      system "cargo", "install", "-vv", *std_cargo_args
    end

    # Install bash and zsh completion
    output = Utils.safe_popen_read("#{bin}/deno", "completions", "bash")
    (bash_completion/"deno").write output
    output = Utils.safe_popen_read("#{bin}/deno", "completions", "zsh")
    (zsh_completion/"_deno").write output
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
