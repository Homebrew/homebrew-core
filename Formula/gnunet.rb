class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.16.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.16.2.tar.gz"
  sha256 "b5858833836509b71d5c0d9bdc11fd1beeeaba5a75be4bbd93581a4d13e0f49a"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6bad58cf144de22e85e7bc4a85f1031b1600a48853081c6ea781b69e5595c86e"
    sha256 cellar: :any,                 arm64_big_sur:  "441f62d9d893661ecb673c98ea47b0150f0095e51bde1c21807649cd831edcf8"
    sha256 cellar: :any,                 monterey:       "be78601e85b300ec3ff21d6a92ea41129516cbb063c95a7785024993ba25cef6"
    sha256 cellar: :any,                 big_sur:        "407728549a1b319068dfcfd8b50312d558cee8f0aa878e026d4126545e65ddeb"
    sha256 cellar: :any,                 catalina:       "af648249cd1012111ce4b25c9ff114bc53f91def0b45bb76e87ba86bd0f8313b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93acdc3700cb2c4c7aca9ee85a9df1ba77b5c38b60adb18811b1eff62834ee55"
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
