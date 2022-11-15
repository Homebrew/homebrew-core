class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.9.8/onig-6.9.8.tar.gz"
  sha256 "28cd62c1464623c7910565fb1ccaaa0104b2fe8b12bcd646e81f73b47535213e"
  license "BSD-2-Clause"
  head "https://github.com/kkos/oniguruma.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-](?:mark|rev)\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ce1351a948c52a2d0fb08e3c1eba5c1cd8ac22abb9c348299fb7b95a81e7a56d"
    sha256 cellar: :any,                 arm64_monterey: "6c66f5d4198bfd9d9be019f4f40d19f4c68676df9eb0702f450ec818ef43d3e9"
    sha256 cellar: :any,                 arm64_big_sur:  "0c9cd371a4baa9cf7322d3083aaf3d6c77f0d676a3ad2db6c80ee5e19c89367a"
    sha256 cellar: :any,                 ventura:        "877e5ee7b7af6f8c219ce3525526f7608adb89cec960759aa4f9d1a5d290661d"
    sha256 cellar: :any,                 monterey:       "680427d257a0ec9851f736e09c07ca3a808710ce57635024d8ddf31543c8c6db"
    sha256 cellar: :any,                 big_sur:        "2abcc410df54889260ec1dc5cdb93cbe22ee01d4df5bff97d2ab43b4aaad3afb"
    sha256 cellar: :any,                 catalina:       "000bae49a7219387f2a94e2c675113d241217702cde7f424e3590d7350270dc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3e431432a920a795798426fe7a32b5536909947d8a23970c4274029b8d03607"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-vfi"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match(/#{prefix}/, shell_output("#{bin}/onig-config --prefix"))
  end
end
