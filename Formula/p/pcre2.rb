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
    sha256 cellar: :any,                 arm64_sequoia:  "c3f9e7a70ebc0986af6f0b7c69ac1495fdf4c7420ad831d3daa9c86c448b79c2"
    sha256 cellar: :any,                 arm64_sonoma:   "78fe8885f70cc1ec83eefd678e1dfc3b341aedf4b44132327da98300c5e04cdf"
    sha256 cellar: :any,                 arm64_ventura:  "58f5a3b0858236149a5792e1c1238510b3757c632d436e87b17acd8045dbeba2"
    sha256 cellar: :any,                 arm64_monterey: "fe61ece0fe110928cbd9d325552064c1bc2b98a3dd6cc9f4039d0d41ead7fa83"
    sha256 cellar: :any,                 sequoia:        "5bf0758d81478e59007717b43d854a1e2399818c2859fcbc5cdb2e616e4eb372"
    sha256 cellar: :any,                 sonoma:         "c39e89e49f9ab7a8b5ae5efcdd38b27df9003e62a045b336117041da939d3136"
    sha256 cellar: :any,                 ventura:        "22151e6b0e120939ec8240add51c3de8aecf0b716f8c91f97b7c106698ecb40d"
    sha256 cellar: :any,                 monterey:       "ba8ab5793b9399926030e574ed376c003749ea775ca62c713b732b8d35fc1bfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbddfbb9921fa2894640db7f0395ea8a79ce5209ebe5ae6700762d0452a6910f"
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
