class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "https://www.pcre.org/"
  url "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.46/pcre2-10.46.tar.bz2"
  sha256 "15fbc5aba6beee0b17aecb04602ae39432393aba1ebd8e39b7cabf7db883299f"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^pcre2[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c11090dbc1b3d2adfc60b57f98e0d2ff7b2516e5660771a85d40f208aac254e3"
    sha256 cellar: :any,                 arm64_sequoia: "6ddb89f2eef25f73e258a97bf4379539e24ea76e207fa3c0eb49222bdb656de2"
    sha256 cellar: :any,                 arm64_sonoma:  "71828b19933d1cd002d61e6cca11f22f4810bc0f8c5d0c98e9094362a80dcbeb"
    sha256 cellar: :any,                 arm64_ventura: "6b38069079a641040e1cf8c408afbf902384d70bcc8fdbd445a9acc31e1e70d1"
    sha256 cellar: :any,                 tahoe:         "361022584a32a993bd36215b8dae43ec23caea95bb58881254bc31f943037ea4"
    sha256 cellar: :any,                 sonoma:        "8de0e4e72fe26f37b904fbf124b7fb6672f8839b76c6bc6ee8b105ba647334a1"
    sha256 cellar: :any,                 ventura:       "e71e438a81766aafffd719f90ba93cdaa158f91c08e19d96428fa841da15bd5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca24c56a72883fcba1a51d2e0ccd7f0e8243026b63c9a7d9b72f33f289822ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ceb1547e7a0f58c840a449ae638b83d3eeb224d7780f027f4eb096f0752df70b"
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
