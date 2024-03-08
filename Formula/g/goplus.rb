class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "0e28ad347b39f151449ce1cb0ee17057491d8f9e6d34365367d9e2207e514309"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "46ec3df41dc4e4958c519a82b1ba720a7827fda9fe11b7cd91a2299590b470ce"
    sha256 arm64_ventura:  "26126540a5de2e2d2c81a87898fe01f2d505cea6b906ae71249e05ad65361e01"
    sha256 arm64_monterey: "43d4dc56c2bb62b738d79a0c2ad3fae26f74e5d1a1996ee1a904f423a2045378"
    sha256 sonoma:         "c8526531b89058f918d90313df681752640d5b7684490ec9234151ce4874203a"
    sha256 ventura:        "dc0981095db192742589900cbb5b6010dff9346aa4b58bffce1aa4368e1bc488"
    sha256 monterey:       "61ecc80d9603decf85719778a08a49b29f83d0d456388597a783680e8552ce1f"
    sha256 x86_64_linux:   "0a1fc359f2e7fbe92a133716871b51093f451345f84e7735f5a7a85884ff3003"
  end

  depends_on "go"

  def install
    ENV["GOPROOT_FINAL"] = libexec
    system "go", "run", "cmd/make.go", "--install"

    libexec.install Dir["*"] - Dir[".*"]
    bin.install_symlink Dir[libexec/"bin/*"]
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
