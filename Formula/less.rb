class Less < Formula
  desc "Pager program similar to more"
  homepage "https://www.greenwoodsoftware.com/less/index.html"
  url "https://www.greenwoodsoftware.com/less/less-581.tar.gz"
  sha256 "1d077f83fe7867e0ecfd278eab3122326b21c22c9161366189c38e09b96a2c65"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/less[._-]v?(\d+).+?released.+?general use/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_big_sur: "c7bc35b8debbb322fc3bdd644ba526eeec3ab8d5f982c76442995a763c77c739"
    sha256 cellar: :any, big_sur:       "431d227c11a0d52bb4d4392244615933d9f04265f36faedc93f5406226d38076"
    sha256 cellar: :any, catalina:      "491fc7dc78848cd91c85c4a6a1ff5457166c0ad83dda9f05145489c2aa2828eb"
    sha256 cellar: :any, mojave:        "d03e895349d8503cea9c8da326015298bf64d80796ab9ee62138a4a072e4559f"
  end

  head do
    url "https://github.com/gwsw/less.git"
    depends_on "autoconf" => :build
    uses_from_macos "perl" => :build
  end

  depends_on "ncurses"
  depends_on "pcre"

  def install
    system "make", "-f", "Makefile.aut", "dist" if build.head?
    system "./configure", "--prefix=#{prefix}", "--with-regex=pcre"
    system "make", "install"
  end

  test do
    system "#{bin}/lesskey", "-V"
  end
end
