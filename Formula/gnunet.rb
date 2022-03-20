class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.16.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.16.2.tar.gz"
  sha256 "b5858833836509b71d5c0d9bdc11fd1beeeaba5a75be4bbd93581a4d13e0f49a"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "de55ad7b59ee82375065931a70d9e1f84ecb772f18c1ffdb176cb60c1ba893b1"
    sha256 cellar: :any,                 arm64_big_sur:  "a800f0ad74e22c1bd38d2c899d9349a80e1daea77b5cf4a20fb981df43b6caf5"
    sha256 cellar: :any,                 monterey:       "a9feb7b41a7d1c1c69ed0840244a1616758cb129f2b2c60d1302140f4e23a135"
    sha256 cellar: :any,                 big_sur:        "d6189389002b05470549a66d419e5903c5e8cbc3d3a13018208ea4436f0169a4"
    sha256 cellar: :any,                 catalina:       "5a8e262752e7bcb0a522943a3d4b13b61625b4416a741676c44df1a018e5ed76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8c2fedd07e283c997c2c3c73db448534f08d51a72deb048e300697167f7af48"
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
