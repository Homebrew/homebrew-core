class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20230321.tar.gz"
  sha256 "ed7d568c08748a2221e19ddc1aebed97dd430ab0c6942304698b1c2363fa8256"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae1af2246b36dc4d23df735b503958629fcc4573771d093f5b24c4a7690fd61b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10c2daf51aa24c62badb511aa70c9fe481b944913ce850335c28ee0b9fd88797"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58cbba47c78136a11b41f9d456d265b6aa7ce3b101d82a19c9c496c359ba9c18"
    sha256                               ventura:        "48bc18ff770adae462dac5a2035bea913e7bc9da36ee51d6e8386bdd573e4627"
    sha256                               monterey:       "e4f23bc065e809bbbf129d17566a07b0f8cd10d327cabf0d7e6628912b8f703e"
    sha256                               big_sur:        "b64add26743d7ffec701f153d72086861bace3605214c986f8fac0016c596e87"
    sha256                               x86_64_linux:   "5437a6f71a9397eb604de1bf2c1782a7774bfe149807f90192e603470b2926c5"
  end

  def install
    # Don't pre-roff cat pages.
    inreplace "mk/man.mk", "MANTARGET?", "MANTARGET"

    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    # shell-ksh test segfaults since macOS 11.
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install", "BROKEN_TESTS=shell-ksh"]
    system "sh", "boot-strap", *args

    man1.install "bmake.1"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all: hello

      hello:
      \t@echo 'Test successful.'

      clean:
      \trm -rf Makefile
    EOS
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end
