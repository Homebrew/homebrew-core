class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.20.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.20.0.tar.gz"
  sha256 "56029e78a99c04d52b1358094ae5074e4cd8ea9b98cf6855f57ad9af27ac9518"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d89d3de6ce37b653142678e5a08bbcc457521fa2220f7b7c40bfc6851fa9829f"
    sha256 cellar: :any,                 arm64_ventura:  "81fc020cce9c1a070db69e8b9f9ac433a8cecee206a6f9e1170910deed10a48b"
    sha256 cellar: :any,                 arm64_monterey: "22bd3ec3ee2b752e6f68fb2bb6968f3c03bc8170d2e3106c3b073ecf7cc17fbc"
    sha256 cellar: :any,                 arm64_big_sur:  "4149465b6dea58fe81d6137dd34b8be0694b76c2edb7aefe30a29e5d924f67d6"
    sha256 cellar: :any,                 sonoma:         "6c5ae81c5b931c95d8e0dda90dca72cbfd15dcb5681eba19b24ea407a5ad870c"
    sha256 cellar: :any,                 ventura:        "879feb9a82281ef9f84ecce2b396adad09f5fe33f960b02d3e04b91a218e2e5e"
    sha256 cellar: :any,                 monterey:       "6dcde89d85af48fdfcedc86ba96d813cc07900f21a093b59ac0312b79c8eb182"
    sha256 cellar: :any,                 big_sur:        "185248d135529c2b82059bcec8af98f4d25f0eaeb7274ebc052bb7708a69b437"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1885e8064fd15f0eb97cd0783db086d227f3284e3bad1339131d6b80c40c6b9a"
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
