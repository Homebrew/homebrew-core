class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https://github.com/goplus/llgo"
  url "https://github.com/goplus/llgo/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "fdf145f85b2570a50e4bdf29ae2bf93f2197b16546e3bce37c4622eee97f39cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "abc5716d772b22aedbdda36a3cb5baf4fdf530658e29aa0885e17a3e5be9f7a0"
    sha256 cellar: :any,                 arm64_ventura:  "ad30f0756be67379f590cf8b9c67f30fffabe97ec37aaad6e4fcdd75aa648a11"
    sha256 cellar: :any,                 arm64_monterey: "3dbff3f8d50f91fc69ebd99a2a613cc62c1b8ce7a9a1125b3ca7067fb535ba1a"
    sha256 cellar: :any,                 sonoma:         "7f934f76c9ad4c8bafe6ca1489396b1721883e96846b290bf38f5d3fa7cb5924"
    sha256 cellar: :any,                 ventura:        "4bff48ed3503b926fce89e079e0de2c5350ef1fe4928c1cdad1a78980d4f2ed4"
    sha256 cellar: :any,                 monterey:       "fbe63b1b5c5325df3ce31d4d0a1f6a926eb92f6ec9ae84564c33d0dc70781132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a442a318be75c0eff9c372c54120eb99d4c0be3093887caa6b4b8da6eb0e8479"
  end

  depends_on "bdw-gc"
  depends_on "cjson"
  depends_on "go"
  depends_on "llvm"
  depends_on "pkg-config"
  depends_on "python@3.12"

  def install
    ENV["GOBIN"] = libexec/"bin"
    ENV.prepend "CGO_LDFLAGS", "-L#{Formula["llvm"].opt_lib}"
    system "go", "install", "./..."

    libexec.install Dir["*"] - Dir[".*"]

    path = ["llvm", "go", "pkg-config"].map { |f| Formula[f].opt_bin }.join(":")

    (libexec/"bin").children.each do |f|
      next if f.directory?

      cmd = File.basename(f)
      (bin/cmd).write_env_script libexec/"bin"/cmd, LLGOROOT: libexec, PATH: "#{path}:$PATH"
    end
  end

  test do
    (testpath/"hello.go").write <<~EOS
      package main

      import "github.com/goplus/llgo/c"

      func main() {
        c.Printf(c.Str("Hello LLGO\\n"))
      }
    EOS

    (testpath/"go.mod").write <<~EOS
      module hello
    EOS

    system "go", "get", "github.com/goplus/llgo/c"
    system bin/"llgo", "build", "-o", "hello", "."
    assert_equal "Hello LLGO\n", shell_output("./hello")
  end
end
