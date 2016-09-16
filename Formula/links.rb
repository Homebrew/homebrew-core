class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  # Switch url & mirror back over when twibright is responsive.
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/l/links2/links2_2.13.orig.tar.bz2"
  mirror "http://links.twibright.com/download/links-2.13.tar.bz2"
  sha256 "c252095334a3b199fa791c6f9a9affe2839a7fbd536685ab07851cb7efaa4405"

  bottle do
    cellar :any
    sha256 "9b47581bba7ce7e119756d20997642f6b48404387b159c517f94cc829c10903e" => :sierra
    sha256 "72f73ee61f9b16ae1e8bbe1306900a1fb17cfd49576f166bb88ab574ec8b0925" => :el_capitan
    sha256 "490a0aa8d1116268d3a431d9c1442dc9a2bd94fb00a74f0cab3767622ea119ac" => :yosemite
    sha256 "65ed8437744babda1c9653b7944b5e77b1147d235424948c1c98309b15c9ccc8" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "openssl" => :recommended
  depends_on "libressl" => :optional
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
    ]

    if build.with? "libressl"
      args << "--with-ssl=#{Formula["libressl"].opt_prefix}"
    else
      args << "--with-ssl=#{Formula["openssl"].opt_prefix}"
    end

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
