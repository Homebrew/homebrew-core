class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.16.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.16.3.tar.gz"
  sha256 "3239052f13537a9aabaaa66ec42875dbee2f6838c5f18b3aef854e6b531ec38a"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "108c8fdc3ee5d175120f2b65cb02069c79910f5df649c64a608266e601ac858c"
    sha256 cellar: :any,                 arm64_big_sur:  "9303d1a10ea0ef4327dbd075fd383d33f43fa7f56aeb4dcc07ca43a4a784b148"
    sha256 cellar: :any,                 monterey:       "aa90d9891a2c1f29a9118471ea3b007199653e849f9f06adefd2963d9ffbf215"
    sha256 cellar: :any,                 big_sur:        "750cdbdec2ca9d019b4a97ac568afcfb9259d91e3ae3390f6f61cb0dc6fc41a3"
    sha256 cellar: :any,                 catalina:       "51a6a15e31fcea7c166dfda09b16efc72941928ce2fca545fe8db77fab53cbd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ade592f3ac70c6a80c5fc49673ae2818a66f7d7564ebef849b53c2472b18458"
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
