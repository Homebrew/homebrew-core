class Less < Formula
  desc "Pager program similar to more"
  homepage "https://www.greenwoodsoftware.com/less/index.html"
  url "https://www.greenwoodsoftware.com/less/less-581.2.tar.gz"
  sha256 "ce34b47caf20a99740672bf560fc48d5d663c5e78e67bc254e616b9537d5d83b"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/less[._-]v?(\d+(?:\.\d+)*).+?released.+?general use/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f23024af4d1356f53bb5878fbbb41bd5da0943db524e9317a5f1e90a3ae88af2"
    sha256 cellar: :any, big_sur:       "3a13526e660b8d2b6725a48000be76f4d79e4178e516c137b807968e0faabdd8"
    sha256 cellar: :any, catalina:      "e92c22994edb092737b72ea43911063ae2fdafe8b98692fbcadaced1f0b31f74"
    sha256 cellar: :any, mojave:        "ac57fc123c84d43490749f55e7e6ed0605821fbbe62fc0d503c71c00f568137b"
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
