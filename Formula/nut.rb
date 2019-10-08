class Nut < Formula
  desc "Network UPS Tools: Support for various power devices"
  homepage "https://networkupstools.org/"
  url "https://networkupstools.org/source/2.7/nut-2.7.4.tar.gz"
  sha256 "980e82918c52d364605c0703a5dcf01f74ad2ef06e3d365949e43b7d406d25a7"

  bottle do
    rebuild 1
    sha256 "521801a19b4cc0af4a7b1257c7cab01b8857ea54b1d93873f511abceaf8639f7" => :mojave
    sha256 "402d11c8de791487a264320826d4e71d27458f09adaaa275f00a620732c36137" => :high_sierra
    sha256 "f25e46baa1c36f3ffb09b4b1c9253b4bcc1ddd301c176af278a5f81a89f56859" => :sierra
  end

  head do
    url "https://github.com/networkupstools/nut.git"
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"
  depends_on "openssl" # no OpenSSL 1.1 support

  conflicts_with "rhino", :because => "both install `rhino` binaries"

  def install
    if build.head?
      ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
      system "./autogen.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--with-macosx_ups",
                          "--with-openssl",
                          "--with-serial",
                          "--with-usb",
                          "--without-avahi",
                          "--without-cgi",
                          "--without-dev",
                          "--without-doc",
                          "--without-ipmi",
                          "--without-libltdl",
                          "--without-neon",
                          "--without-nss",
                          "--without-powerman",
                          "--without-snmp",
                          "--without-wrap"
    system "make", "install"
  end

  test do
    system "#{bin}/dummy-ups", "-L"
  end
end
