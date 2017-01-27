class I3 < Formula
  desc "Tiling window manager"
  homepage "http://i3wm.org/"
  url "http://i3wm.org/downloads/i3-4.13.tar.bz2"
  sha256 "94c13183e527a984132a3b050c8bf629626502a6e133e07b413641aec5f8cf8a"
  head "https://github.com/i3/i3.git"

  bottle do
    sha256 "3d5076ab193c0a768508a2fc1d3d64f163a065409c02856efb373ad2b762b6ca" => :sierra
    sha256 "f3e957e4d41877752572eaab1527f72e10800e33b359d49d101a5543c303a55b" => :el_capitan
    sha256 "10a9482d01d9c681d9bf9ddabb0ee437d29ba9c5b215b9352acda20821bb329b" => :yosemite
  end

  depends_on "asciidoc" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build
  depends_on "cairo" => ["with-x11"]
  depends_on "gettext"
  depends_on "libev"
  depends_on "pango"
  depends_on "pcre"
  depends_on "startup-notification"
  depends_on "yajl"
  depends_on :x11
  depends_on "libxkbcommon"

  resource "xcb-util-xrm" do
    url "https://github.com/Airblader/xcb-util-xrm/releases/download/v1.0/xcb-util-xrm-1.0.tar.bz2"
    sha256 "9400ac1ecefdb469b2f6ef6bf0460643b6c252fb8406e91377b89dd12eefbbc0"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    resource("xcb-util-xrm").stage do
      system "./configure", "--prefix=#{libexec}/xcb-util-xrm"
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", "#{libexec}/xcb-util-xrm/lib/pkgconfig"

    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}"

    cd "x86_64-apple-darwin#{`uname -r`.chomp}" do
      system "make", "install", "LDFLAGS=-liconv"
    end
  end

  test do
    result = shell_output("#{bin}/i3 -v")
    result.force_encoding("UTF-8") if result.respond_to?(:force_encoding)
    assert_match version.to_s, result
  end
end
