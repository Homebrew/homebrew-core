class Deno < Formula
  desc "Command-line JavaScript / TypeScript engine"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v0.29.0/deno_src.tar.gz"
  version "0.29.0"
  sha256 "e61d961b5b6a05ecc50205e856b122da223216f28f3156bc26ad6aef9e54e0c2"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fa3af6f918ede4bb5c7f222c9f1c880aa8a57bddedfde9976b4dbce2d9459c6" => :catalina
    sha256 "e07e86107e97d6bf051c433b9b80a547fdf3a32373467fbbfe93095a5ceb7ae7" => :mojave
    sha256 "3a4e86ba8b0c7f6e8a763459c7e4a3eb8f01b89870fd8417eb45fc4d8e27765d" => :high_sierra
  end

  depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1100
  depends_on "ninja" => :build
  depends_on "rust" => :build

  depends_on :xcode => ["10.0", :build] # required by v8 7.9+

  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
      :revision => "a5bcbd726ac7bd342ca6ee3e3a006478fd1f00b5"
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
    if DevelopmentTools.clang_build_version < 1100
      # build with llvm and link against system libc++ (no runtime dep)
      ENV["CLANG_BASE_PATH"] = Formula["llvm"].prefix
      ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    else # build with system clang
      ENV["CLANG_BASE_PATH"] = "/usr/"
    end

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
    hello = shell_output("#{bin}/deno run hello.ts")
    assert_includes hello, "hello deno"
    cat = shell_output("#{bin}/deno run --allow-read=#{testpath} https://deno.land/std/examples/cat.ts -- #{testpath}/hello.ts")
    assert_includes cat, "console.log"
  end
end
