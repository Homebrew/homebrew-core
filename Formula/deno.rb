class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.6.0/deno_src.tar.gz"
  sha256 "60491d842e04ce162face61bb8857bf18a41726afbcbcd9fa532055ace7431ae"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "190465b6a68bae086d5ae26d97e9b293a4be7a246eb2ada4aac4c5d94f681435" => :big_sur
    sha256 "8095e1d9e273f8ce1adac4c0b1693b1df6faa129d5296c5b82804671bf1eac66" => :catalina
    sha256 "87f6302f877d9c74ea3ad828cf24d2a52dcb1bb2ce1d7c9aa2ad76b2b2316a09" => :mojave
    sha256 "247cda1c657ebe3995be4ad958631f61b9270d16abe76fecb1e5a10870ac917c" => :high_sierra
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
      shell_output("#{bin}/deno run --allow-read=#{testpath} https://deno.land/std@0.80.0/examples/cat.ts " \
                   "#{testpath}/hello.ts")
  end
end
