class Deno < Formula
  desc "Command-line JavaScript / TypeScript engine"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v0.33.0/deno_src.tar.gz"
  version "0.33.0"
  sha256 "a4e5e9760b10ed3d31b5578f7ab19c63c72886dd142de8d294b20b882c2e502d"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab97d241ed0a588f2297dd2d83bf95144868406daec44c16214a597be6a6dc1c" => :catalina
    sha256 "affaf68bddc2434f219244fd556b1dfc6380570872ec15f4b5e81fc3a8c444f7" => :mojave
    sha256 "28b955127900481160fdf16a5a76c8bdc9932d750ef9f1b4209d93a10d7f685f" => :high_sierra
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
    cat = shell_output("#{bin}/deno run --allow-read=#{testpath} https://deno.land/std/examples/cat.ts #{testpath}/hello.ts")
    assert_includes cat, "console.log"
  end
end
