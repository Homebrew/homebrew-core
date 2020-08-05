class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  url "https://github.com/OpenSC/OpenSC/releases/download/0.20.0/opensc-0.20.0.tar.gz"
  sha256 "bbf4b4f4a44463645c90a525e820a8059b2f742a53b7b944f941de3c97ba4863"
  head "https://github.com/OpenSC/OpenSC.git"

  bottle do
    sha256 "38a3b5cb96dc21a68ecb7a5ec55cb4e16245718f43494442c43c7bf1dfbc9cbd" => :catalina
    sha256 "a4f9ffe8088a618dc349e74463ac7a846335dc847b8dc37c8037ec8c7e3244de" => :mojave
    sha256 "ec40e0b292df9c7819244653977a7ce03b1121f2f98cf2960c0e6f611f18eaf1" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-openssl
      --enable-pcsc
      --enable-sm
      --with-xsl-stylesheetsdir=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl
    ]

    system "./bootstrap"
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      The OpenSSH PKCS11 smartcard integration will not work from High Sierra
      onwards. If you need this functionality, unlink this formula, then install
      the OpenSC cask.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opensc-tool -i")
  end
end
