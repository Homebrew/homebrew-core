class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "https://www.pcre.org/"
  url "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.44/pcre2-10.44.tar.bz2"
  sha256 "d34f02e113cf7193a1ebf2770d3ac527088d485d4e047ed10e5d217c6ef5de96"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^pcre2[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "45c605d79f321f1afcab9192841fb6440f97693440ed6ccb8242edb3118303f3"
    sha256 cellar: :any,                 arm64_ventura:  "4369d231c0a816d72fd879e50ac170c4c43fea24772ea9ca2cb1e5c86de24418"
    sha256 cellar: :any,                 arm64_monterey: "ce23b3c3a974b28c4a88537a92b33eb97d36ef6677f7d486264e391358573465"
    sha256 cellar: :any,                 sonoma:         "be3af696b4ae7aa059dec0f7da50884e7a928584d44462739779345ac370620c"
    sha256 cellar: :any,                 ventura:        "1eb4d125dca380f54c78d75f1c77543b1b847e5fbf585c276ff1bae831d67067"
    sha256 cellar: :any,                 monterey:       "af0d9f0935efc5c6a7a18ae15d399a65998ea5915e4c412a7620fafaf342c833"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cd2e07bac70157bd9cc46e7a882d62b549f496dd85999595de9828a37fbec1c"
  end

  head do
    url "https://github.com/PCRE2Project/pcre2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-pcre2-16
      --enable-pcre2-32
      --enable-pcre2grep-libz
      --enable-pcre2grep-libbz2
      --enable-jit
    ]

    args << "--enable-pcre2test-libedit" if OS.mac?

    system "./autogen.sh" if build.head?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"pcre2grep", "regular expression", prefix/"README"
  end
end
