class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20250225.tar.gz"
  sha256 "cc19b15438b454e334a23a8c91e3b87fd4b8be08c6fd9500d48e55cc683bba10"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36d52222847a69ed08bb551b8968aa97055651147386bde2cf16609b98a0679e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e83ed8d13d43be577c51d34ed503938324a068a019b9575c83d113db03daa053"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e38af867ff08da365c450013c51fae92e536bd4a41058d41ebff84fd4469f24"
    sha256                               sonoma:        "8fc3a7161b7f38a9ee9138e9f92f9df69840767ada4600203ad068992b875cf7"
    sha256                               ventura:       "16439b8a295855461a7872d65af6732533c26d59d6c3b0100b62c42e949b148a"
    sha256                               x86_64_linux:  "eda28f9d899e4461ceb9125aa32da82405589d1fe0aaf78e669cdd60b5600497"
  end

  uses_from_macos "bc" => :build

  def install
    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    # shell-ksh test segfaults since macOS 11.
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install", "BROKEN_TESTS=shell-ksh"]
    system "sh", "boot-strap", *args

    man1.install "bmake.1"
  end

  test do
    (testpath/"Makefile").write <<~MAKE
      all: hello

      hello:
      	@echo 'Test successful.'

      clean:
      	rm -rf Makefile
    MAKE
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end
