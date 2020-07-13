class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.2.0/deno_src.tar.gz"
  sha256 "6e11ede5328df66a6044ca1f514a47a01e851d33ae4ebe531eb67b19d6f0448e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ec98829f0fd012242845099236bd6d51d86638bff237b669a60d6f64c4f6b3fe" => :catalina
    sha256 "33086b7a5100ab2a6ee9fcefb006e2421610bd49edd5186c1619f35bf81bd0c2" => :mojave
    sha256 "fbeaa845d6d96efa4a096d56b34499197887932e3809ff3e8bce43421641e99e" => :high_sierra
  end

  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on :xcode => ["10.0", :build] # required by v8 7.9+
  depends_on :macos # Due to Python 2 (see https://github.com/denoland/deno/issues/2893)

  uses_from_macos "xz"

  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
      :revision => "5ed3c9cc67b090d5e311e4bd2aba072173e82db9"
  end

  def install
    # Build gn from source (used as a build tool here)
    (buildpath/"gn").install resource("gn")
    cd "gn" do
      system "python", "build/gen.py"
      system "ninja", "-C", "out/", "gn"
    end

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
