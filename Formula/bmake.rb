class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20230522.tar.gz"
  sha256 "dfe556df70e1555b70eccf4e6d367aa8b91aa076d5e9b55e36b5ce3e721f9050"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66fb905c4aca1f78f6ca8b6c0b0f34680d89199a0971143944b3c3a33b8c8686"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d714799ad19d1fdf4e7e2f6709577b35bf111876f263d2d85fbc8cfeb1b11ddc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ecc7433f360b9871d18145f7fb2008c8973ef972822b9acb1dff20a3001e956e"
    sha256                               ventura:        "9c4578f87d36119648dd81692ec4ad76c46eb4adeddaa7e44f9e526f13210544"
    sha256                               monterey:       "e63cd32883da186f376608e164bd2934ff192b0afee85002262639f872a71668"
    sha256                               big_sur:        "0f1822459824a4a5d7fcc2f3d76fb2319b010235f331f292678ef21f65ac3b6e"
    sha256                               x86_64_linux:   "0131a2e0372a557d6fbb0f11bbb58d0a642b29f21c89d14ee8eab942ff1d1a32"
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
