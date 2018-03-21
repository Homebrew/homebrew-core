class I3 < Formula
  desc "Tiling window manager"
  homepage "https://i3wm.org/"
  url "https://i3wm.org/downloads/i3-4.15.tar.bz2"
  sha256 "217d524d1fbc85ae346b25f6848d1b7bcd2c23184ec88d29114bf5a621385326"
  revision 1
  head "https://github.com/i3/i3.git"

  bottle do
    sha256 "830cfa4eb9b25d0f26c941a01419a093c014417f2f2ee6e78a828ea922868671" => :high_sierra
    sha256 "88f9c1c997ea6c4b5f3886854a599900a7b01b0bdce5ce82b46c04f71ea82201" => :sierra
    sha256 "c5999c78a3af9072039638eee8c6a2b5d3ef006c402b049da9cb3ef45dcdbac0" => :el_capitan
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
    url "https://github.com/Airblader/xcb-util-xrm/releases/download/v1.2/xcb-util-xrm-1.2.tar.bz2"
    sha256 "f75ec8d909cccda2f4d1460f9639338988a0946188b9d2109316c4509e82786d"
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
