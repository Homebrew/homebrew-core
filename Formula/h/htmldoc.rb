class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/archive/refs/tags/v1.9.18.tar.gz"
  sha256 "be5368912062e6604fdf2ecffe4692c4b31764dbd83578e7dd5b457e42c007b8"
  license "GPL-2.0-only"
  head "https://github.com/michaelrsweet/htmldoc.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "b5862b0ead7bad774ddea06553f4fed4adab8b7c2eba4d9be47d212892149e30"
    sha256 arm64_sonoma:   "b3daefc48f25c937c30c5a7d8dcc4b74e042ba33c24d804b4c9a5ac8f8112182"
    sha256 arm64_ventura:  "195a8758cd0ed5bc3bd6acb57786bc44ec896a4c340429e31278ad5076730086"
    sha256 arm64_monterey: "5bebc747c06a7a7a1126786f9b55a516dd7ba93d517639eae4f0327ace137296"
    sha256 sonoma:         "d7cf9d6323503a41782c3abba270cff6c2065ad5241f084ac00d4b495286e92a"
    sha256 ventura:        "ddb2695cb9af62aa13d49a8e8dbc6103f57a3eb5d02b434e083f215d0de35a3b"
    sha256 monterey:       "eae62c45aaa7d1961d7693053f3d1997f13ae23464f9f1158afcff57c45cebe2"
    sha256 x86_64_linux:   "415b9a4e9cc544df43b3d2de79f08bbb5ce2d2c391bdafc2ef7c9f268f509aac"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "cups"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gnutls"
  end

  def install
    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--without-gui"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"htmldoc", "--version"
  end
end
