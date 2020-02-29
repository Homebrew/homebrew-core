class Deno < Formula
  desc "Command-line JavaScript / TypeScript engine"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v0.35.0/deno_src.tar.gz"
  sha256 "49a0a0f208c246f08ab5bd00b3d4eb8936b98e19533c164cb11c458f12dde9e5"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a4bd15ec2777e420d81c2cd68ddb1834a64a2ba37053a30412140b4fcae53be" => :catalina
    sha256 "cb412afcc5f41f7d6ca8e72bdfd650e89a8fb0e8e08a213b37a429308c42ad5e" => :mojave
    sha256 "d760ba1b15355725f9a3026dd23acb92bacc31b6aaf82efbfb06731806e52170" => :high_sierra
  end

  depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1100
  depends_on "ninja" => :build
  depends_on "rust" => :build

  depends_on :xcode => ["10.0", :build] # required by v8 7.9+

  # Does not work with Python 3
  # https://github.com/denoland/deno/issues/2893
  uses_from_macos "python@2"
  uses_from_macos "xz"

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
    cat = shell_output("#{bin}/deno run --allow-read=#{testpath} https://deno.land/std/examples/cat.ts #{testpath}/hello.ts")
    assert_includes cat, "console.log"
  end
end
