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
    sha256 "4a6b8c4b43e331548c53ef20d35be15156ff7cef5d3e6a2400f1e5eeff14c02b" => :big_sur
    sha256 "7c2200588b517d1c797a8307031f2ca20a3145547ff4cd5ed182fc5680671e5b" => :arm64_big_sur
    sha256 "5ba13391a55bcd288e0ab35458503bea761213e3e5a4395ea0966e2d19deb03f" => :catalina
    sha256 "89526a544b8fb886dbbf62710c30a6c52f339d48240ca72afe1f99098394ee11" => :mojave
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
