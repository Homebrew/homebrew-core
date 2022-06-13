class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.27.tar.bz2"
  sha256 "d8ddcbfcede7cdde80abeb0a236358f57fa6beb2bcf92e109624e9b896f9ebb4"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://links.twibright.com/download.php"
    regex(/Current version is v?(\d+(?:\.\d+)+)\. /i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d144ac3578be1db12a070229f46d39eb34d1cddb8bfc27b425d999be74908237"
    sha256 cellar: :any,                 arm64_big_sur:  "d4cebe3bfc41563dc8f30bdce62b290d8e4ad014731ea86dcccfd0c0872f1710"
    sha256 cellar: :any,                 monterey:       "c4c098ab932b778ea8d90eb7f6a9b1059f5d34458f0ea6de65751aaca62fd1fe"
    sha256 cellar: :any,                 big_sur:        "6127bfa01abcbf37f597d52d8335a68f0a1ea7ef76aa5b304cc5c44bc14d17a6"
    sha256 cellar: :any,                 catalina:       "b9a844178275ee01275c2f243aa474a2bd33e4f47eb058fb78d2ef1d640312e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b911c32060a18c19ea4eeae549a60523dc068122ad3df059e4ece6c27d10ecbf"
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
