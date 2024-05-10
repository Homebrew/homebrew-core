class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.29.tar.bz2"
  sha256 "22aa96c0b38e1a6f8f7ed9d7a4167a47fc37246097759ef6059ecf8f9ead7998"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "http://links.twibright.com/download.php"
    regex(/Current version is v?(\d+(?:\.\d+)+)\. /i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a863dc752622dddf4fdd5826e4c0bc325454974edc95c563057128a5db270868"
    sha256 cellar: :any,                 arm64_ventura:  "e4540d989d8df24a0d763b4dc535576fbb211e650649af2c9099169e096034a1"
    sha256 cellar: :any,                 arm64_monterey: "2cde4b9112e61d1a69a3d9db2bee59c77bf64d23bfed82fbd81b1071416c413d"
    sha256 cellar: :any,                 arm64_big_sur:  "2e0ff6048ef5e174bd94968f1d396287fcaffb953239559595aa4bf8b4cd188c"
    sha256 cellar: :any,                 sonoma:         "4a98731343c82217a7b7b9fdb421edce2b40a09ad7b0850f3382c0068f21ee97"
    sha256 cellar: :any,                 ventura:        "52131e67784ec2407a7ebdf3a0a4374cf67035fdb79f2a81df4f1c3fb66607fa"
    sha256 cellar: :any,                 monterey:       "b250161b88f02bda634cb0ff689ea54310c6eaefc12de9eb1b87d4e18e8cab58"
    sha256 cellar: :any,                 big_sur:        "0aa338ed370f3071ef1a015e8417890d91fddf7742618c4a5e2c66c98a730276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af912ec13c9a8f37b63312cf7c4fa971c31dab5c41aed62bbad9a0377d0c2a2c"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
                          "--without-lzma"
    system "make", "install"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"links", "-dump", "https://duckduckgo.com"
  end
end
