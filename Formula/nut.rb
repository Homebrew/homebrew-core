class Nut < Formula
  desc "Network UPS Tools: Support for various power devices"
  homepage "https://networkupstools.org/"
  url "https://networkupstools.org/source/2.7/nut-2.7.4.tar.gz"
  sha256 "980e82918c52d364605c0703a5dcf01f74ad2ef06e3d365949e43b7d406d25a7"

  bottle do
    sha256 "3f5166d461e19f8e6eb838215ba1502fb6ec039a94cdab3d88a5ccdf62c675db" => :mojave
    sha256 "102d8b6e9635321a7585d79c8c3c95d0f973c91cbf031be4d6839cf10c06ad2d" => :high_sierra
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

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"
  depends_on "openssl"

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
