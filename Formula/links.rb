class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.21.tar.bz2"
  sha256 "285eed8591c7781ec26213df82786665aaa1b9286782e8a7a1a7e2a6e1630d63"
  license "GPL-2.0"

  livecheck do
    url "http://links.twibright.com/download.php"
    regex(/Current version is v?(\d+(?:\.\d+)+)\. /i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4f1d1a7db600814dc6ba06ba8d146d1449ea34a706bc651e44a5205739bd07f7"
    sha256 cellar: :any, big_sur:       "4e8063e73e66dc0650d28ea07dea15e4a05659664185e96c26c716263e29cf2b"
    sha256 cellar: :any, catalina:      "c43cf180508872a2e5461af4c3c80a58d2d8824d1bb8b0c1a7d0f890aa12ef49"
    sha256 cellar: :any, mojave:        "aef8fa60ec4bdc8adca1cab129a2a8fd0a44888d867e7b468a1ed7672f7c7550"
    sha256 cellar: :any, high_sierra:   "6660756b8d9ac4a433212c44067fd1627e96c3bcf7996f4a51da1affe39e29e5"
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
