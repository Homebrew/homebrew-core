class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "51db5c4116fd229d7cd65c3b45552dc0cd7aa9c89798a9ba71ae2f0f243c7f05"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia:  "fe0832efcd98cc11821ead934130a36a38b58990ca730a1a5ac266abd17d7cd8"
    sha256 arm64_sonoma:   "30286ecee2169db6a0e94bba10db54b4e64f1b7d9515645577b63792fafd9717"
    sha256 arm64_ventura:  "82b9263ee8902427ae05adef43e88d03b706d7777e3fa642b2469a28824e30d2"
    sha256 arm64_monterey: "41709633aaebd432c31033b3aaa859244e82916f121533c503124afdbaf8fcac"
    sha256 sonoma:         "47c58fe9d037ebb24bd73a19b27465393be5f266fca5675a9064f0cdfa18548c"
    sha256 ventura:        "99f652be78900129bb9fd131df5c8b6b8b40630c71f4447c75288b5c65e3c510"
    sha256 monterey:       "ab73c20e21526ee3b2e6f905f9a14a29e56f292b61c8f8ab9dc7e4ce10491e80"
    sha256 x86_64_linux:   "ae23a9efa61937f365d0d248e8da1b210de1e31d49ad6d89a9940eeb64c17162"
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

    assert_equal "v#{version}", shell_output("#{bin}/gop env GOPVERSION").chomp
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
