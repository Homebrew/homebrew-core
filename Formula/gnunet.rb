class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.17.5.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.17.5.tar.gz"
  sha256 "8a744ff7a95d1e83215cce118050640f6c12261abe4c60a56bcf88e500f0023d"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c67f46ea10a8286ff92e72ea4613635e8acc7e4df8900aa40faad0c733571997"
    sha256 cellar: :any,                 arm64_big_sur:  "961caa01a5a6dd1813cedfa4c0b7578a647668bad9e42cc4fdeb35959792cc9d"
    sha256 cellar: :any,                 monterey:       "d6ead1367a5a2ecd88ee684fb38bbb2624166a588dab29b6d8c12d07092549dc"
    sha256 cellar: :any,                 big_sur:        "5225660ade36a2fa11d0a05d217bef128068cf82db182c10ac192843e8f32829"
    sha256 cellar: :any,                 catalina:       "559ecc0a42ab11f7b9a43c45230812f2b08b538ac764f8acb5583d4c59b25690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad6d518e300932c28f367ca5e340677ac064bcb592944bb9d0928cadbaafa5cb"
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
    system "./configure", *std_configure_args, "--disable-documentation"
    system "make", "install"
  end

  test do
    system "#{bin}/gnunet-config", "--rewrite"
    output = shell_output("#{bin}/gnunet-config -s arm")
    assert_match "BINARY = gnunet-service-arm", output
  end
end
