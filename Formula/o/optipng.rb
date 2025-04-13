class Optipng < Formula
  desc "PNG file optimizer"
  homepage "https://optipng.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-0.7.8/optipng-0.7.8.tar.gz"
  sha256 "25a3bd68481f21502ccaa0f4c13f84dcf6b20338e4c4e8c51f2cefbd8513398c"
  license "Zlib"
  head "http://hg.code.sf.net/p/optipng/mercurial", using: :hg

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d7f218d549637362a08fa6f6ee66b1557ab007472ede88d63957de611b15ad34"
    sha256 cellar: :any,                 arm64_sonoma:   "c1b42258526f71e84ecda4f7e72ca8c8a9e6685179a7b0b792d37c29cbbb03a2"
    sha256 cellar: :any,                 arm64_ventura:  "ad99b4693060ef805451b6d3a3bc9c2fbbdec2284d18395a686eeba68d33a5d3"
    sha256 cellar: :any,                 arm64_monterey: "c560ecc7ba7c3f33620b4d808e498ee8d1cdb693da8830424aa2de76fc8561a9"
    sha256 cellar: :any,                 sonoma:         "345a986c5e59c4c14d43500de9862e5b3c09f75916da5d979603877d0b27f844"
    sha256 cellar: :any,                 ventura:        "03b4a5b9aba8fa77b708a64417d26362860fcbfb8b563b4d2fa7f1be2e15135a"
    sha256 cellar: :any,                 monterey:       "86ff3ec0b11f375a0efe8b02bfd6e39d929199623f6b898651ce5f565983f685"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "00f72faa1368f7044ca97f70b724063c41dda652061ee00c8c0eb7025f960a7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e41ab8506824deb6ce70a14bef6d4c9d15209e1c19316934c859e6111fccee4"
  end

  depends_on "libpng"

  uses_from_macos "zlib"

  def install
    system "./configure", "--with-system-zlib",
                          "--with-system-libpng",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"optipng", "-simulate", test_fixtures("test.png")
  end
end
