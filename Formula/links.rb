class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.15.tar.bz2"
  sha256 "1e2a1c4b439c14fbedd78fd98f443af2ab0c1566bebc491642411d74b7efe3ca"

  bottle do
    cellar :any
    sha256 "2b351a90eaaa0e01aea3e1f35a7f0f0f82c906192adab8e40e0ca65b6b0bb15d" => :high_sierra
    sha256 "6343a489437c4f554661a22bf384f4aeee22aa0ba54352e43813771d8257f520" => :sierra
    sha256 "2440c0535f4ff077a1697a45e3d495bf5dae85b9126460915fc84b5f7a62e491" => :el_capitan
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
