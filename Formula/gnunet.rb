class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.16.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.16.1.tar.gz"
  sha256 "df8026dd0b1c285ebc57e820e6b29e87c3d0f210bb0899f6b5317261f8e01c5c"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3a900fb89f0c64b6604beaa05536293bc240ee06bbb194ef62faf7c4274929f3"
    sha256 cellar: :any,                 arm64_big_sur:  "ddfdb4e1c3f173de71d7dfb5907038482bc3e8614583e3ae80974e5cb934bdad"
    sha256 cellar: :any,                 monterey:       "383df9ac171406f25d6211c447b80a9bcefb63f4a008cb0199df7635cdce25c2"
    sha256 cellar: :any,                 big_sur:        "2344ed238253c7d3d188b127328231f01039cbb8abb82bf24dd4b4a0777afee5"
    sha256 cellar: :any,                 catalina:       "bc24218876482a74d42a2020456586c4e4538ad157075c1458e9169c3afc66e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "936291436614687ac62b5b10f25b8be0f29df652dd7e5cd9986d9d904eb823a1"
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
    system "./configure", "--prefix=#{prefix}", "--with-microhttpd"
    system "make", "install"
  end

  test do
    system "#{bin}/gnunet-config", "--rewrite"
    output = shell_output("#{bin}/gnunet-config -s arm")
    assert_match "BINARY = gnunet-service-arm", output
  end
end
