class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.22.tar.bz2"
  sha256 "0364986b3a7f1e8e3171bea362b53f71e1dd3360a8842d66fdc65580ebc2084d"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://links.twibright.com/download.php"
    regex(/Current version is v?(\d+(?:\.\d+)+)\. /i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "240394fc7d383abd1dc92b09eef316444b9143d3c1f5ecfe4ec6d9aabffbb879"
    sha256 cellar: :any, big_sur:       "7244e77024332dc3c3564cc12afa15a4ab0a3fb95cbb053f85f7816e48e19c45"
    sha256 cellar: :any, catalina:      "fd1264189ca279e0d73395410babcbe53ca75820a6ba25c97d85da856e515fdf"
    sha256 cellar: :any, mojave:        "3a54b72901034d1e251059266041854c030429622418e61768c9b8a20486e5cb"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "openssl@1.1"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-lzma
    ]

    system "./configure", *args
    system "make", "install"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"links", "-dump", "https://duckduckgo.com"
  end
end
