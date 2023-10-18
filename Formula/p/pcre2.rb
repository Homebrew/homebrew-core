class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "https://www.pcre.org/"
  url "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.42/pcre2-10.42.tar.bz2"
  sha256 "8d36cd8cb6ea2a4c2bb358ff6411b0c788633a2a45dabbf1aeb4b701d1b5e840"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^pcre2[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f9abacbf5d8f637449706d2bc3ed80c4d25963c014fcb5bea5bc9e5828badef0"
    sha256 cellar: :any,                 arm64_ventura:  "8423a338c590ab1a6f265b39a9d1a67ab1361a586f0e494a8c9555cff2867536"
    sha256 cellar: :any,                 arm64_monterey: "23ce93cf86bd4816b7d039efa0a5d68c751bce3f552a8cbf41762518b4be199e"
    sha256 cellar: :any,                 arm64_big_sur:  "69483f445671a54f0e03f96b7ef41218913f793a84c32cf98de1e79aa029fbf1"
    sha256 cellar: :any,                 sonoma:         "c090875eb7e346dd5fdc5fc05902e89a306312549e754591bd1f619578349e99"
    sha256 cellar: :any,                 ventura:        "7f414ed9d561dc85aacd41c7d18a452d3f58a6fe73af02b8fb876483080ec4df"
    sha256 cellar: :any,                 monterey:       "76ccbd45954e84db49558afca66ff135e615e5c9069bafe519ce9a1029e17530"
    sha256 cellar: :any,                 big_sur:        "1d858ca3171ba18bc70ca3980bafca1ce5ec65eb6550ff87d4f5facae0dd3b32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fb73ccbfd7f7d48b9400512ded73383a19dc54ec015ab1aab2b849480c3b3f8"
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
