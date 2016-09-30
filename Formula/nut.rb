class Nut < Formula
  desc "Network UPS Tools: Support for various power devices"
  homepage "http://www.networkupstools.org"
  url "http://www.networkupstools.org/source/2.7/nut-2.7.4.tar.gz"
  sha256 "980e82918c52d364605c0703a5dcf01f74ad2ef06e3d365949e43b7d406d25a7"

  bottle do
    sha256 "45949916c354f6c3ba50df8ada5690f36d15ca1114185f1d92f66c4b08110f63" => :sierra
    sha256 "df1f1a4b7efa73d48ada9d97ec13983fd1ba674773a058f771044dcd841a4b79" => :el_capitan
    sha256 "d544abc34f9ed56f76fae104b8a472fe081c5072e32aeddbbd674316e9c0931d" => :yosemite
    sha256 "83183c2346ec3642b45a20e47439225d94a58d6617669dd2001922f12d544942" => :mavericks
  end

  head do
    url "https://github.com/networkupstools/nut.git"
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "without-serial", "Omits serial drivers"
  option "without-libusb-compat", "Omits USB drivers"
  option "with-dev", "Includes dev headers"
  option "with-net-snmp", "Builds SNMP support"
  option "with-neon", "Builds XML-HTTP support"
  option "with-powerman", "Builds powerman PDU support"
  option "with-freeipmi", "Builds IPMI PSU support"
  option "with-cgi", "Builds CGI wrappers"
  option "with-libltdl", "Adds dynamic loading support of plugins using libltdl"

  depends_on "pkg-config" => :build
  depends_on "libusb-compat" => :recommended
  depends_on "net-snmp" => :optional
  depends_on "neon" => :optional
  depends_on "powerman" => :optional
  depends_on "freeipmi" => :optional
  depends_on "openssl"
  depends_on "libtool" => :build
  depends_on "gd" if build.with? "cgi"

  conflicts_with "rhino", :because => "both install `rhino` binaries"

  def install
    if build.head?
      ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
      system "./autogen.sh"
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --localstatedir=#{var}
      --without-doc
      --without-avahi
      --with-macosx_ups
      --with-openssl
      --without-nss
      --without-wrap
    ]
    args << (build.with?("serial") ? "--with-serial" : "--without-serial")
    args << (build.with?("libusb-compat") ? "--with-usb" : "--without-usb")
    args << (build.with?("dev") ? "--with-dev" : "--without-dev")
    args << (build.with?("net-snmp") ? "--with-snmp" : "--without-snmp")
    args << (build.with?("neon") ? "--with-neon" : "--without-neon")
    args << (build.with?("powerman") ? "--with-powerman" : "--without-powerman")
    args << (build.with?("ipmi") ? "--with-ipmi" : "--without-ipmi")
    args << "--with-freeipmi" if build.with? "ipmi"
    args << (build.with?("libltdl") ? "--with-libltdl" : "--without-libltdl")
    args << (build.with?("cgi") ? "--with-cgi" : "--without-cgi")

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/dummy-ups", "-L"
  end
end
