class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.21.tar.bz2"
  sha256 "285eed8591c7781ec26213df82786665aaa1b9286782e8a7a1a7e2a6e1630d63"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "0a3c7483bcee4795978c8db90bdf2f07a46baa09cb6258a620f7d89e4724a466" => :catalina
    sha256 "82b66ce4fc6e261197ad6d00110a6963620772b4e1e0b553c4c982e39c363fa5" => :mojave
    sha256 "8c04e068acff9290a354b2c244638ca27056a086b67b90fac90e6bbfc1a7215b" => :high_sierra
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
