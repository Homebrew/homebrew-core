class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.17.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.17.3.tar.gz"
  sha256 "74c767b8d0c34f60ddfa4e77a1657365d34c484b5ffaeb3796e3f520a9d50c9e"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7703a7b006d9ad183f82ea546d124e04935cc5cd4f7723b5e1ace36eaea37ecf"
    sha256 cellar: :any,                 arm64_big_sur:  "f16e8beeadcc27d611d599791854685e047f10831367670100d329f9549b4b53"
    sha256 cellar: :any,                 monterey:       "79b5036e0ec4ad82dc56e9db1960c4774576757d6b777f0b69e201e205b1aa1b"
    sha256 cellar: :any,                 big_sur:        "b6d39591fe941389b4750d75c04c9c5722107810b77a2654d295995ba828f23b"
    sha256 cellar: :any,                 catalina:       "9e8baa6302cb51a42b14223424d5658db612d6ebfae762b15badd9879f898196"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b8eeaf9bdbf8a2b994fcf672a90a8995a3e0dfca50e38e45bc164f6bbe3d756"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libextractor"
  depends_on "libgcrypt"
  depends_on "libidn2"
  depends_on "libmicrohttpd"
  depends_on "libsodium"
  depends_on "libunistring"

  uses_from_macos "curl"
  uses_from_macos "sqlite"

  def install
    ENV.deparallelize if OS.linux?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "#{bin}/gnunet-config", "--rewrite"
    output = shell_output("#{bin}/gnunet-config -s arm")
    assert_match "BINARY = gnunet-service-arm", output
  end
end
