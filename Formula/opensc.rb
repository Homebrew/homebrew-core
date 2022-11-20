class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  url "https://github.com/OpenSC/OpenSC/releases/download/0.22.0/opensc-0.22.0.tar.gz"
  sha256 "8d4e5347195ebea332be585df61dcc470331c26969e4b0447c851fb0844c7186"
  license "LGPL-2.1-or-later"
  head "https://github.com/OpenSC/OpenSC.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "ff63000387afc269b6c1effaabcbec8bc0af5f4bff1547790d850eb2f564cb79"
    sha256 arm64_monterey: "e36b99415f0289b18c89b41a018e410b689008d282e6bcc645563075725b3ff4"
    sha256 arm64_big_sur:  "a784ed8b0ef0ec7dd1ca997331424d4899ffac2b3774a5424e1c0da2d180022f"
    sha256 monterey:       "0956e69b33a8e39e9c7345a086d446472c55cb79fe2082c9c34535840b9ff23a"
    sha256 big_sur:        "5b46706b6ed0a2104cccb2511b830b289882ef92d9d263a4ee951090e068549d"
    sha256 catalina:       "447703c3545b2d5114c5f105af76269d01ef2830e00e7bb8057f33650bca2060"
    sha256 x86_64_linux:   "36ee5e4298c955fad69d97e94732c8a159a4beadbc8f918041b2614e3111f222"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

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
