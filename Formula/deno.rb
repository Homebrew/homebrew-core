class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.5.3/deno_src.tar.gz"
  sha256 "a85d6bf67e3dc0adaf87fe785351a34a0331571970f8229b652175a884bc9599"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "71914084795b9ff20746b5c76b22473010fa6833c4bf1d12f0465fd7a4e9e664" => :big_sur
    sha256 "fc1dcecb2965c1f7723c977293a1948e740260fe21965001772d676fb024bad7" => :catalina
    sha256 "de2fee0b4aadff92cc96ea36ae35fa5c3f7f6db1ee5ad4deff400f8985587839" => :mojave
    sha256 "9cdb03d72540613e54a8d638b6e736bf662866d132712c06882626e2b9785554" => :high_sierra
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
