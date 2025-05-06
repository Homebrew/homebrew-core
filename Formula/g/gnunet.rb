class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.24.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.24.1.tar.gz"
  sha256 "c4f8f9d25d3a00f80709583b87aa8312d01454090b73a413b43ec7ec7c07ba39"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "1b2ace0ac8ed3de46232cce757c6c17821abcf62f77db2379b210bfeebbd245d"
    sha256 cellar: :any, arm64_sonoma:  "affae8cd659814408ccae7f16116fec13e4c2323c12e3c8555858af87260a86e"
    sha256 cellar: :any, arm64_ventura: "b77cc1cb7afd855da6308b5ec725145f8792a1e048d0912578bf7525a939e83e"
    sha256 cellar: :any, sonoma:        "d6f3e8caa1ee63145f269ecf7f64f383106e55acb05b25a32d43ae5062de7d06"
    sha256 cellar: :any, ventura:       "34886996f1f93ad7bfd44329ce84ed89ce0ff00f420fe8a5a34715482a832aa7"
    sha256               arm64_linux:   "6da4308d9cc5120910b0706cdf52223b4b59c19db299495b43094ada6212fc19"
    sha256               x86_64_linux:  "bfe12d34758600c26177abbd086a427fda4bf334d5d3f2446716632e32f03e1b"
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
