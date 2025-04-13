class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "https://www.pcre.org/"
  url "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.45/pcre2-10.45.tar.bz2"
  sha256 "21547f3516120c75597e5b30a992e27a592a31950b5140e7b8bfde3f192033c4"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^pcre2[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f2abc87de6796a4e639f93d42c6d515cad90418fd7b701bcf322fb8e1443704e"
    sha256 cellar: :any,                 arm64_sonoma:  "549a4a79676a6e2c58896cb46cf7d36a8c86f3696e61c43f07dca6660c32cd08"
    sha256 cellar: :any,                 arm64_ventura: "a780535fb2f47a39bd16d28f966da1c99b868d7e15b2d18b75b509b6deb85e0d"
    sha256 cellar: :any,                 sonoma:        "5b1916e8e569da37aabc596561eb93a6bdf7cff4d55d35a351576c071ce723cc"
    sha256 cellar: :any,                 ventura:       "83722732df9490388e3fa729d06063fbd3fe7e245b0269c5b67f736ffa8c9ba5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5081c77793061bb49fd74ffdefee2b52cdf49df0d2f9799888d943a826dac75a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a5727c5e1b6d0aa922bc2d30ae6510dca32f1b738a7501bcdf18823c59e120e"
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
