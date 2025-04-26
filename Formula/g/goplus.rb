class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "b3332363f70cc1dc4a28e283ff4885923fdaa90b215e03770bf1b6f94969dc20"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "f51cfefc2db9795e1f893d9eeb0fa2732c253822457610bdb65a6f0764b29fc9"
    sha256 arm64_sonoma:  "c5379db482e0fc17712066512e92e5ae6b19871e196f2c8bf908041364487d16"
    sha256 arm64_ventura: "87ae4ae61e709bba7f628b6fa4f7ebf120b3b5486b5623f62bd44f6de1b71ab4"
    sha256 sonoma:        "f57140541bb05d2442f524cf367fc97b010a2cbb9bbb734f98830da3f9800afb"
    sha256 ventura:       "64541d5ae52eeee89ae7d025cc96b6c4382133f3e11592ba5a8b4ec14931bccb"
    sha256 x86_64_linux:  "21ab27babdbfcf7dbe1ebbd48ee96e0f15ec0607fbf852380cc3e15c1b41b20f"
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
