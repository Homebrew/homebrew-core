class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.13.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.13.3.tar.gz"
  sha256 "318e06c4134d1a8ce3b4385d82b11316eaaeb9a4dbc5d4b646453dfc53199296"
  license "AGPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "cea8501f8fa52cbb4b1d1af8628d4c0f09f3f3ae667a45f0445ab79e47c5b255" => :big_sur
    sha256 "413b9db61db66ea96a9f1cbbb3471c35313ff195c1c1ee10d526e37e59f92fbf" => :arm64_big_sur
    sha256 "1e2b31e022792cc40dcd11061644808f761e378a2178b1bfdd9191a31363ad1e" => :catalina
    sha256 "ef84c90eb8ea9783adbaaa8b7034cb0662d7b697d2e5b7953365bac1681d5277" => :mojave
    sha256 "5470d0894a0ca01ca53d3376e4bbc7ad038621827e7ff1e075e1dd2c07c579f3" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libextractor"
  depends_on "libgcrypt"
  depends_on "libidn2"
  depends_on "libmicrohttpd"
  depends_on "libmpc"
  depends_on "libsodium"
  depends_on "libunistring"
  depends_on "unbound"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/gnunet-config -s arm")
    assert_match "BINARY = gnunet-service-arm", output
  end
end
