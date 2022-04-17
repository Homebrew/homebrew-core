class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "https://www.pcre.org/"
  url "https://github.com/PhilipHazel/pcre2/releases/download/pcre2-10.40/pcre2-10.40.tar.bz2"
  sha256 "14e4b83c4783933dc17e964318e6324f7cae1bc75d8f3c79bc6969f00c159d68"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^pcre2[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f0633818b37d8d3ce88c882e048ada77e58f1f445a41e35b028d23e8866fc5ab"
    sha256 cellar: :any,                 arm64_big_sur:  "935bb0c71f1ab79e0ef2593b519b62b5489d87d4571b320cd8f93050c820c450"
    sha256 cellar: :any,                 monterey:       "07b546fdbe6af636fc750abb0104fecd998bc6f40899a75229f89b49f96c1e3b"
    sha256 cellar: :any,                 big_sur:        "3b6478346d722d13c9dd556a90949319417224006939b1e46b06a189dc8c5262"
    sha256 cellar: :any,                 catalina:       "583378673b021a431d4f987ae609fe2a53f834c4e37bca20178e48e94efe77cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8b88708df04038ec6e29fbecd7b4c7d1d7fa8792da09aa56401de8117b5e3b5"
  end

  head do
    url "https://github.com/PhilipHazel/pcre2.git", branch: "master"

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
