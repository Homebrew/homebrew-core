class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.4.6/deno_src.tar.gz"
  sha256 "a99444a8021455237efb2e52dc608a7747693c8609a4911cad97e10de9d83756"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c87ed99a746547c9cf12645efaab9c1524623ae5b9d24e6d080f8ebf1f8e8b1" => :catalina
    sha256 "20d85bf6b72b5c2c3ecc11ff62c4a2c4fc3aff30908af3c25e3c65825494fa1c" => :mojave
    sha256 "f970d2b968681cf8eb8129cc591952694f976ea5c21df092e6cc1c6753ca63f0" => :high_sierra
  end

  depends_on "llvm" => :build
  depends_on "rust" => :build
  depends_on xcode: ["10.0", :build] # required by v8 7.9+
  depends_on :macos # Due to Python 2 (see https://github.com/denoland/deno/issues/2893)

  uses_from_macos "xz"

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
