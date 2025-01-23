class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.23.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.23.1.tar.gz"
  sha256 "6fd05b69076b3b1a8e7e20b254e044fdd4c6da5313196317f3de088f7d025cf2"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "15797564cf281fc48e58e9d96e1f86348e0320082ea0044e4d2fef8dd35e6e95"
    sha256 cellar: :any,                 arm64_sonoma:  "ac3646e173da3bed97e3e61e841ebbef29903f3f5899b6df4a27f71df9501ea2"
    sha256 cellar: :any,                 arm64_ventura: "e527744dd0cdfafad96a34309d4ac4e7328451e15a615436374aa4e3b3819774"
    sha256 cellar: :any,                 sonoma:        "0fc8d62658746a3a1632ae2a31e4e5af5b5bcf62753492c27476a639be5f501a"
    sha256 cellar: :any,                 ventura:       "ba21f56397adcad7f116bc24697ee1fe774053fb474f8859cbdb4e3c23601d2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ac3072699a9e63f67b894dc08f71c7fa7fcd6e42d59da7617b59b987d0d1c47"
  end

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
    ENV.deparallelize if OS.linux?

    system "./configure", "--disable-documentation", *std_configure_args
    system "make", "install"
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
