class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20231210.tar.gz"
  sha256 "1d44f4cb9fa95cc5bfb663553f5a0d041e135e4de167b7c79582b24ca54fbaed"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0347145e79bd26a26ed8a867f7bdf0ee233e66be485a20b66a9d210a087061e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "942cda2462315f3f5de007fb169b6e69d4ea9bdb5a2bcaed61e8d71e85b22638"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bc87fe73023300ad0ea7468143d352ed0b5485edad970d468cb7f4fb6b0dc30"
    sha256                               sonoma:         "74b3b64be23d98d47c243e2f4b88bd173bf4231bf8b398f7b847bf41c7cc0183"
    sha256                               ventura:        "935dc0438a8aab0976cadacef6ff0afb532f680efa381eb3ab91145b4ba3c70a"
    sha256                               monterey:       "2997bdd579cd0e46d8fd8dac0ffbc15231ae66a2bb82df3475223e3bb97660ab"
    sha256                               x86_64_linux:   "242465a694fa222967abede428c9f79b198e4ac8d8734e4d8fdfda32d624adcb"
  end

  uses_from_macos "bc" => :build

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
