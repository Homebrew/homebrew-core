class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.17.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.17.1.tar.gz"
  sha256 "75de0a715e3e969286483ec6ae4b25a87365664d42cdfb606df8e746a15f1265"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "488dd8a59fcbe9c1e5a395efa02121998a5a9fd1999a4b9b76269584af1b9615"
    sha256 cellar: :any,                 arm64_big_sur:  "02338566adee0a3208517d825d52bff67901326b5a5e086a34b37a291f840e54"
    sha256 cellar: :any,                 monterey:       "3d42043f2b0ecc3769778cb23eecbee431d4b4652bc73b991b49fcc92c3c5d3f"
    sha256 cellar: :any,                 big_sur:        "256cbb7ab27cb8cc89361dfcf4f6720923792d7e75e58505552dd9181f35f1a8"
    sha256 cellar: :any,                 catalina:       "9289d962c431ac5d696ddcb535c8316ab3c79c5a385fb9c06d8b07ad08809668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa28dfb86b1a90e267817b4b38af8f85ef8bb835818c390838ae86293a4d463a"
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
