class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.28.tar.bz2"
  sha256 "2fd5499b13dee59457c132c167b8495c40deda75389489c6cccb683193f454b4"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "http://links.twibright.com/download.php"
    regex(/Current version is v?(\d+(?:\.\d+)+)\. /i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "94c4e2c60e55c797cba12f8e32e7c16a5e5b0117ba79680c41e5ec8dc587d963"
    sha256 cellar: :any,                 arm64_monterey: "86447d391cbadebc15d53bdba2dc5e824d7a8fd554ac9e805894f58dab48f6d5"
    sha256 cellar: :any,                 arm64_big_sur:  "eeb988eb931d99c381b413f7623596aafe8f0c8c573b5291cbaf157115046ee1"
    sha256 cellar: :any,                 ventura:        "5c15b0dc7ba7ed27f06cf198b2043bbc4a8ce194f42b6b5b56e8453c8643a391"
    sha256 cellar: :any,                 monterey:       "d472501f6e0e5f18babd9f3f40503d774229ba9476034c7e0eca8455cce2870c"
    sha256 cellar: :any,                 big_sur:        "4dcfbaad5a0e797b81674c6454912b2a9ab192af1f8e434794a4a3938a6e0d82"
    sha256 cellar: :any,                 catalina:       "0d676b66beb64c78ba9d6e1e4af1e2c533a3e2ce2c9c6fa826edb525ff86ec5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cf574763d64bf60fa5f757fb70c560cc65934cd410e7a581a099e188849578d"
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
