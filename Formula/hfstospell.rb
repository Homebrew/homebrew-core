class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.3/hfst-ospell-0.5.3.tar.bz2"
  sha256 "01bc5af763e4232d8aace8e4e8e03e1904de179d9e860b7d2d13f83c66f17111"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "796beb095d1b2986eff942e38f3ab2617e77d6d122975d0a365f780c830085f4"
    sha256 cellar: :any,                 arm64_monterey: "d57d423f827ac8c30760cd0b95469c8c569be08593c60c64ab047814e9825f38"
    sha256 cellar: :any,                 arm64_big_sur:  "cd6b3c5df4b0e362e4fa7920215e3b1dc55cf42987bd4dd6c561dd5d17348875"
    sha256 cellar: :any,                 ventura:        "5f2e6d771dc31bade8620afa59f6f0d14a1b289309adfefda80fe6708d92f81a"
    sha256 cellar: :any,                 monterey:       "a9f3bee7b2fc4f1899fd4f35f04418af652cd330ec903b2d311f7bcacf9f1e8d"
    sha256 cellar: :any,                 big_sur:        "d7abf56144b444cdb50b360af19cfe000481d488137fe7171f4e6fb3a0537f9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "038a9a1dccdb9c4fd4a87abc9a293d5442eab61e02e274195c675cdefbc30834"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "libarchive"

  def install
    ENV.cxx11
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-libxmlpp",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/hfst-ospell", "--version"
  end
end
