class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.14.tar.bz2"
  sha256 "f70d0678ef1c5550953bdc27b12e72d5de86e53b05dd59b0fc7f07c507f244b8"
  revision 1

  bottle do
    cellar :any
    sha256 "82e39d92b7653ba187d2de6b5a9c760319e8ba8d4c9898a12f96dc6f7ae5f256" => :high_sierra
    sha256 "dce0530efd47157b5ab5e96ffe91324134fa5dc957ed1343e38dd04de209a5d9" => :sierra
    sha256 "334ae37d4e41f8bfcf86e8a4ec543db97a357f315cf4778b41c8039e2ce78a3c" => :el_capitan
    sha256 "61690764c8f0b3f4246b8099e0b1216a2585f70c97c53d5dbd8d2fd04efb19c9" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "openssl" => :recommended
  depends_on "libtiff" => :optional
  depends_on "jpeg" => :optional
  depends_on "librsvg" => :optional
  depends_on :x11 => :optional

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --with-ssl=#{Formula["openssl"].opt_prefix}
      --without-lzma
    ]

    args << "--enable-graphics" if build.with? "x11"
    args << "--without-libtiff" if build.without? "libtiff"
    args << "--without-libjpeg" if build.without? "jpeg"
    args << "--without-librsvg" if build.without? "librsvg"

    system "./configure", *args
    system "make", "install"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"links", "-dump", "https://duckduckgo.com"
  end
end
