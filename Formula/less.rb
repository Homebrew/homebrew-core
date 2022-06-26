class Less < Formula
  desc "Pager program similar to more"
  homepage "https://www.greenwoodsoftware.com/less/index.html"
  url "https://www.greenwoodsoftware.com/less/less-590.tar.gz"
  sha256 "6aadf54be8bf57d0e2999a3c5d67b1de63808bb90deb8f77b028eafae3a08e10"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/less[._-]v?(\d+(?:\.\d+)*).+?released.+?general use/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6342e6c36bbb6fb617994ff5904e389d3a3a15826f25097e6d60450a30b3c89d"
    sha256 cellar: :any,                 arm64_big_sur:  "bc5f182ccbe6676c1647939b2dd1b66e4f66eb920bb865f94d041fccdb2bd493"
    sha256 cellar: :any,                 monterey:       "c619cd7da95e0b54f9b75c8737e4745df5b83d918a8ee7d09a8b94e1a3f635b0"
    sha256 cellar: :any,                 big_sur:        "7b8ea7c58b438ef80d6b13fd988061543ab3413a40113cd30644cb22fa6f1081"
    sha256 cellar: :any,                 catalina:       "ccbcf747eac1e0a8338be43a6be0e4f3fb241394a6bc0c921b6e51b4ca32c042"
    sha256 cellar: :any,                 mojave:         "916e88216d17654f290affa519d85ad295696dc6c753d3311ed71fb4cc2f9268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d3b89016d59864389e96b2c234f9f8e98254374c1b1d20847a03a8fa8bce6d2"
  end

  head do
    url "https://github.com/gwsw/less.git"
    depends_on "autoconf" => :build
    uses_from_macos "perl" => :build
  end

  depends_on "ncurses"
  depends_on "pcre2"

  def install
    system "make", "-f", "Makefile.aut", "distfiles" if build.head?
    system "./configure", "--prefix=#{prefix}", "--with-regex=pcre2"
    system "make", "install"
  end

  test do
    system "#{bin}/lesskey", "-V"
  end
end
