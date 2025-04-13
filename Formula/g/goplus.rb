class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/refs/tags/v1.3.8.tar.gz"
  sha256 "f81dea9c29f4781b6165e0b4820b15ebbb7e39939f9aa6c49cddac30dca4b2c8"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "69bd2505051f439c1e3c2a99f74b3e7b787a63159282c009648d3ea9c025ca6a"
    sha256 arm64_sonoma:  "797f4fc29567bf093730f407b10179ef0874fc345c71f402f3b420df1ad278e8"
    sha256 arm64_ventura: "e57ed6f3e3adce1853da2443fbe8f056650a5ebebce44a7bd1d4fac23784e801"
    sha256 sonoma:        "a84c8cadfc0a571ba22a15afb88fabbafa27deb56c43538269f11f5484697b48"
    sha256 ventura:       "decebfe9fdabcd63feeafeb648d95fbd8a4a7b842ed22b494d52fb6acc21420f"
    sha256 x86_64_linux:  "9d0dd5cc62b548fc270706238e513d71e4655bd9d0e833ae37dddaaebf893f02"
  end

  depends_on "go"

  def install
    ENV["GOPROOT_FINAL"] = libexec
    system "go", "run", "cmd/make.go", "--install"

    libexec.install Dir["*"] - Dir[".*"]
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    (testpath/"hello.gop").write <<~GOP
      println("Hello World")
    GOP

    # Run gop fmt, run, build
    ENV.prepend "GO111MODULE", "on"

    assert_equal "v#{version}", shell_output("#{bin}/gop env GOPVERSION").chomp
    system bin/"gop", "fmt", "hello.gop"
    assert_equal "Hello World\n", shell_output("#{bin}/gop run hello.gop 2>&1")

    (testpath/"go.mod").write <<~GOMOD
      module hello
    GOMOD

    system "go", "get", "github.com/goplus/gop/builtin"
    system bin/"gop", "build", "-o", "hello"
    assert_equal "Hello World\n", shell_output("./hello 2>&1")
  end
end
