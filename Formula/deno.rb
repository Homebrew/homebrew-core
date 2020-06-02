class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.0.4/deno_src.tar.gz"
  sha256 "2c0551843791064ac4fd4e64e4ed0d49b1d96add1a5fe08457eed903f7859253"

  bottle do
    cellar :any_skip_relocation
    sha256 "3fa97a627bbf200933ba2c96678c2f1010bd8edf4f6a4209aba678053a78bade" => :catalina
    sha256 "75a008074f72ee3a9924259fa0097a8eccf9801f0768dbfeac37781aff812d61" => :mojave
    sha256 "a4c6bde9d66e556242cd2136fdd68b242a05faea7c55a3dbcda8b0134a17cd2d" => :high_sierra
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
      system "cargo", "install", "-vv", "--locked", "--root", prefix, "--path", "."
    end

    # Install bash and zsh completion
    output = Utils.popen_read("#{bin}/deno completions bash")
    (bash_completion/"deno").write output
    output = Utils.popen_read("#{bin}/deno completions zsh")
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
