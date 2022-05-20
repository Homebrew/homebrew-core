class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.26.tar.gz"
  sha256 "c42a4dba21dcfb4525034139489cd47f30aa0c5f9d05b37d4e2eaaea943fe2b1"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://links.twibright.com/download.php"
    regex(/Current version is v?(\d+(?:\.\d+)+)\. /i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0412a60f3601d879a412c3b439e70cb1b3d1448c2e4653612ce025b558174a9d"
    sha256 cellar: :any,                 arm64_big_sur:  "75c23a628dce1edc0b548ec702d250ed8b92939365ec3c975a49d133ace60f2a"
    sha256 cellar: :any,                 monterey:       "cf87869bc114345ff11665dc0a22b882128d15bdbeef9e97433090397fd92a93"
    sha256 cellar: :any,                 big_sur:        "d5a8fe394135df37d8c3ea61dfa0e3a99bdff60c8c108322da48a7aef4fb6ae3"
    sha256 cellar: :any,                 catalina:       "e1b34966182296dce6f81f866fc72089fe7b4a1af5b9084e3faf163a370b5200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0df7751af5188e71d7b73156fd98ca906258bdda4d96fe6d272c66d7ae4e5817"
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
