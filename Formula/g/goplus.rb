class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/v1.1.6.tar.gz"
  sha256 "e96c62e254d5600851b1479e03f05f7b70a91516de28b26b686c4b7f6b4dcb87"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "f2655bcc4256523bbedac33504243317eb722f1487a8d8ade3d5b6f97b3e16d5"
    sha256 arm64_monterey: "dd57548063da4333a46dd58bba1ab370feb1dfea4aab9bd71889701ee30bb811"
    sha256 arm64_big_sur:  "2f5a6dd005220f8d70b162e5b12ec16442fc5b8ca134d8e9faefc31e46397d03"
    sha256 ventura:        "1c483b3cae4196342550cfd4cd1ac56ec2aa29a3b68c63a3dce092de922606fb"
    sha256 monterey:       "84a19d4b70b87964d799c8808703f8e11e50a386de5a0abed61e6a31e87d6d24"
    sha256 big_sur:        "40aa7cd615adbb7489c26aa2f9076e2fb320bdc5c0d1f5b8430de46f613669f0"
    sha256 x86_64_linux:   "162e4b149d60176d919174aca3e5090e3dfd9d3d1b1e4dc721e435c8724e8324"
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
