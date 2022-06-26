class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/v1.1.2.tar.gz"
  sha256 "a68fe2e64a2a183f129b96a225c9ba4638568ae16de3e23d3faa8f6753bb037b"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "2bca85843879449a8aaef13086a037f4e2d84cc783c09a8fd394febd1735b5c3"
    sha256 arm64_big_sur:  "67ce97efd99d1c35fefd958fd9f507d3eb68caf80c9c8c2445b2c8fbb02f316c"
    sha256 monterey:       "fc590548c8213b35c81d8d421eadb4d676eff500591c208d4177d85ffc2fd457"
    sha256 big_sur:        "ad70f4b77a1c8f63683a01abfd81623e52e176e02342ca635c14b0b12555d192"
    sha256 catalina:       "b09a3f21d88ec26bdabccf7dc3af528d69451d6de9ff7b27280c611f616a25e0"
    sha256 x86_64_linux:   "d7cb089004ae6e89d8f2f86619ae66631d609d7dfdd09563d3f19a7302ef9809"
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
