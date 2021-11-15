class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.25.tar.gz"
  sha256 "5c0b3b0b8fe1f3c8694f5fb7fbdb19c63278ac68ae4646da69b49640b20283b1"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://links.twibright.com/download.php"
    regex(/Current version is v?(\d+(?:\.\d+)+)\. /i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "b3e9ad1d3617acdbbc86edbc90f429083130a51eb6ea26b809774b8eaf39fa53"
    sha256 cellar: :any,                 monterey:      "77261cf3aeedfe6b058734536d55b744b80bb52c1cf777a2d78497bd1f4c69e2"
    sha256 cellar: :any,                 big_sur:       "9d7178901279a9ee80768056fa4f2b04676777d5ef2063c9f8a8c2b9f98a8906"
    sha256 cellar: :any,                 catalina:      "1eaa9411f73c61b7a82ee8d16b94bd7c8c0dde86e1eec953c5ce5872394ee073"
    sha256 cellar: :any,                 mojave:        "c12924230d58173c263dcdd827ecb4d9f44bb1e654a191ff5882a46330125cdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6bbd8bae1431f150cc3153f2731cf41cf4fbf06b59033a28b5ac8b72906a792"
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
