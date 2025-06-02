class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.24.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.24.2.tar.gz"
  sha256 "2e4e4a907d9427f0c3dd4d6795cceaf72ccf397e9dc961f60edbef3006f6af47"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "af2636acf5a11352456a134e374990d7fcd4580951426cdbcbe6bbb96a8d5b6a"
    sha256 cellar: :any, arm64_sonoma:  "8f322b053d7dc48f4d9fa35c438d0faabba5003bc1cd37b8da35527b261eac52"
    sha256 cellar: :any, arm64_ventura: "8368079849ace95c5e63057f36980d65cc7c3a56796f91de911e4d7ee8fe6325"
    sha256 cellar: :any, sonoma:        "782b32ce257e45ab046dde173df3f10e1019305e0029b5e37e69318566cb4042"
    sha256 cellar: :any, ventura:       "526442ff3f6462f89f37af5988f399ddf36a1028dbb7b03cb1f745a923c3e2ea"
    sha256               arm64_linux:   "cfdd4c879da77eded343a97611d6acf40052c49c109c81c966bb813687dcbbf8"
    sha256               x86_64_linux:  "8c5d6ca2de92b9653ed6d6461d574a5269b077e37f3d73322efcf1ff003157a7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libextractor"
  depends_on "libgcrypt"
  depends_on "libidn2"
  depends_on "libmicrohttpd"
  depends_on "libsodium"
  depends_on "libtool"
  depends_on "libunistring"

  uses_from_macos "curl", since: :ventura # needs curl >= 7.85.0
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libgpg-error"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"gnunet.conf").write <<~EOS
      [arm]
      START_DAEMON = YES
      START_SERVICES = "dns,hostlist,ats"
    EOS

    system bin/"gnunet-arm", "-c", "gnunet.conf", "-s"
  end
end
