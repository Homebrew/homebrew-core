class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/v1.1.3.tar.gz"
  sha256 "11e676f1ff4a391248747bad9d4c1673d366fcf306bd3e185fee5870afd02fee"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "d5c30712180a7c9a55af310a414bc8861b962fb0d00bbbf95c0d93e0dc0c20cd"
    sha256 arm64_monterey: "3bbea21b81acb18f2dd31d8dfae195b6044aedbe56c6dc092929daa6cf99556c"
    sha256 arm64_big_sur:  "687641bddc2d20cf7a52f9dd4868974011ab2e13b962d5f1fed0718025c97bbe"
    sha256 ventura:        "f5f6dffbf39cc8a2e71c9525de751b67e60f5476e3484bfba45c707878b9197e"
    sha256 monterey:       "c57bbd4e51542b467c353d46485eea935ec9781c35fa7e7d82c795226d34624f"
    sha256 big_sur:        "8dd6ef441b3d38b92a2afb27c3c6d4a0e593d668b67ff57f2ff8dc07cbbfdcf3"
    sha256 catalina:       "f74e821a749f66396d381e9a2648829a53117a552699563aac86e38732bab6da"
    sha256 x86_64_linux:   "4142d7d0efe2f3693c04737fc4858e5b4ceadabaf54209842126340b8bf129e3"
  end

  depends_on "go"

  def install
    ENV["GOPROOT_FINAL"] = libexec
    system "go", "run", "cmd/make.go", "--install"

    libexec.install Dir["*"] - Dir[".*"]
    bin.install_symlink (libexec/"bin").children
  end

  test do
    (testpath/"hello.gop").write <<~EOS
      println("Hello World")
    EOS

    # Run gop fmt, run, build
    ENV.prepend "GO111MODULE", "on"

    assert_equal "v#{version}", shell_output("#{bin}/gop env GOPVERSION").chomp unless head?
    system bin/"gop", "fmt", "hello.gop"
    assert_equal "Hello World\n", shell_output("#{bin}/gop run hello.gop")

    (testpath/"go.mod").write <<~EOS
      module hello
    EOS

    system "go", "get", "github.com/goplus/gop/builtin"
    system bin/"gop", "build", "-o", "hello"
    assert_equal "Hello World\n", shell_output("./hello")
  end
end
