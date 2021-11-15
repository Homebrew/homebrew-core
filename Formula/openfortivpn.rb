class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.17.1.tar.gz"
  sha256 "c674c59cf3201a55d56cb503053982752fb641b13a85ea406b8a7e7df301e30f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "ec8d7033e8e96e347ed56b4fc81ee11805ba23a0f343b1519eb496533f1c5bca"
    sha256 arm64_big_sur:  "c4748e81cb20fb01c9d414e0ed293fc368e564301a5bd30a12331c874110386f"
    sha256 monterey:       "b26201d5191b156c69840c7116e0ba57afb2e32290884d7da3a1826c2aa9f6b2"
    sha256 big_sur:        "bd22ebd6c3c8303346885799b63c8fc75c324d5d5a3b467960852bbc3be0bb7a"
    sha256 catalina:       "4a6d61358a7c7d950cc10c59089eed15fb8b8dfc3bcf345c83a87b08c1308028"
    sha256 mojave:         "07ed32d58eeee4cd3fc6ee3635cd70ad5ecdb67fd0e44265da4784c81b3442fa"
    sha256 x86_64_linux:   "a6e1156d037a572b3f9dcb511bb9d708e6775a7a68027399f5451f690c097cd6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/openfortivpn"
    system "make", "install"
  end
  test do
    system bin/"openfortivpn", "--version"
  end
end
