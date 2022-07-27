class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20220726.tar.gz"
  sha256 "1bf3770789722721dca7b0bff8afc4a9520da20f0219bb7bc52350af0133f0a0"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f39a4986b918dd4487bb240d1a2cb4385f555e80e557934710ba3e0b95be64c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e34b11c2782b979d7f8711be2228ee448fb1c06c075c85ed9eb64b94b78d19aa"
    sha256                               monterey:       "b9dcd0ee4751d5ef2c33900ca230e13721c6212a11808bd4a3c6c12398700e5a"
    sha256                               big_sur:        "86629a8defc22762a130daa5023bcb5215cdb5381f589b095903b886d3f252f9"
    sha256                               catalina:       "f692696a38c182de4436cef3a6265e34753a0ff6c06232e1ec1ed9ec967abf97"
    sha256                               x86_64_linux:   "c0670205ecf9ad71d053b8593061b457eb79368958d250d4ba8f2a215b72139d"
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
