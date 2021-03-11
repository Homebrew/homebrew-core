class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  url "https://github.com/OpenSC/OpenSC/releases/download/0.21.0/opensc-0.21.0.tar.gz"
  sha256 "2bfbbb1dcb4b8d8d75685a3e95c30798fb6411d4efab3690fd89d2cb25f3325e"
  license "LGPL-2.1-or-later"
  head "https://github.com/OpenSC/OpenSC.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "91b2cdd67a4fb7bb63ad572df7959dee38663d303605b9a4f746171dcd85c881"
    sha256 big_sur:       "02a7ab33866d33655995d3ef477135ad32e84ed2d35460ca2824dfa7a7be38bb"
    sha256 catalina:      "3b8ccdec146efba3410eb73fa67340039b13437d5177a620c6f44aafa6c56e57"
    sha256 mojave:        "706b6d81eeed307e64150f4212782da8b49c758995fd92eb32b0cddc85135ff3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  uses_from_macos "pcsc-lite"

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
