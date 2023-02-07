class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.19.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.19.3.tar.gz"
  sha256 "82b7d5fe12d481387c37d2fbf032bb605c2e4d5976079a1947943243e5ba7a25"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0543b619298ccae88133115ffccd15a1730c624f40a9e5e20ec1878b55804361"
    sha256 cellar: :any,                 arm64_monterey: "4696fa3d6293662600510af640969969e880e66a1c65c2963b0dd9bc75eca9c8"
    sha256 cellar: :any,                 arm64_big_sur:  "bf15ce16a04b0378c1e46ce20b4d617d941f63806459e6f74ac114e43d4bc4f2"
    sha256 cellar: :any,                 ventura:        "3331d5f4be5c0652cca294494a48ed2f4047a97bbfa1786df48cba3ed3cd94e1"
    sha256 cellar: :any,                 monterey:       "d3018c0877061f329a003b85acf93122cc8e079d0aa1b609e2873a083a63d992"
    sha256 cellar: :any,                 big_sur:        "e32dc7beb10416719765d0e258d2b14478ebd68e412c9a30ea891e4704269d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5357b90ea207ea84fdbb18d774f2202eb6988aa64c8b984b862d901e757452e5"
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
