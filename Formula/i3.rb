class I3 < Formula
  desc "Tiling window manager"
  homepage "https://i3wm.org/"
  url "https://i3wm.org/downloads/i3-4.14.tar.bz2"
  sha256 "ae3abde3af1b87e269d8aad2348be6f7298338cb8e06bad11cbf91cdbf92a5d6"
  head "https://github.com/i3/i3.git"

  bottle do
    sha256 "ee01c1082bae41555d23d10fcc6091dbea4fd8334663abf8244a9b25f8850801" => :sierra
    sha256 "91bcc3a6d434773f9527817196ae8e4560118f8cdf0cf6ffa5851c59ba635a3e" => :el_capitan
    sha256 "0f9837e29a2d368a1aafbcb03c4f72997fabd3d027f8d36f1a60ed95ef81b065" => :yosemite
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
