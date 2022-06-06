class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/v1.1.0.tar.gz"
  sha256 "523f2974cc3e4ec5ed10b98ca9204b5fb620ab128ae5e8e1dba6e067d9c846b8"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "48d46d61dff999d42287cb988a490d6ff42c6cb580f0bf5ae74131352c665a0a"
    sha256 arm64_big_sur:  "59f14b77576a3a8f02fd4e709a9fd051fbbfea21ff6a6a503fc7cf8c246d205a"
    sha256 monterey:       "3e777abda804515c1df99aca8a36aa4530ac7d01e8e523787daa6c1a5676f5d7"
    sha256 big_sur:        "8f9b4d716337bac8006f688bbc1d98e0e5ef96e0d91ef65503cc8c5bc71bbeb4"
    sha256 catalina:       "a977d90ac6c87f7ddb5e651154ec944d6c744f8ab789a0e6166250b679c348e9"
    sha256 x86_64_linux:   "2c9681fbd62ce1f497046b94039436d98ed1d32ca0aabc89ee2948abda0da287"
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
