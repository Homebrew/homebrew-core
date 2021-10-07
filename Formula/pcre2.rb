class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "https://www.pcre.org/"
  license "BSD-3-Clause"

  stable do
    url "https://github.com/PhilipHazel/pcre2/releases/download/pcre2-10.38/pcre2-10.38.tar.bz2"
    sha256 "7d95aa7c8a7b0749bf03c4bd73626ab61dece7e3986b5a57f5ec39eebef6b07c"
    # fix incorrect detection of alternatives in first character search with JIT
    # remove in the next release
    patch do
      url "https://github.com/PhilipHazel/pcre2/commit/51ec2c9893e7dac762b70033b85f55801b01176c.patch?full_index=1"
      sha256 "0e91049d9d2afaff3169ddf8b0d95a9cd968793f2875af8064e0ab572c594007"
    end
  end

  livecheck do
    url :stable
    regex(/pcre2-(\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "eeda1a0642a9e2a3f32d0588605f29e2a5671dc6bd9e45394c3026cd79786c64"
    sha256 cellar: :any,                 big_sur:       "2e885570c4dc2eaa61e7a02c66631f9333bbb42f8602d8293e7ce022861ae11e"
    sha256 cellar: :any,                 catalina:      "0e40c8534a5fc26eedbbfb487cf437e8b231e0054ccb61c696834416b7160ac7"
    sha256 cellar: :any,                 mojave:        "c6932648a712a0603d786b4b8868a21519eeb13592cf49261359c3c4b0c5665e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6ec10a997623297bbbf00d0d5854235694c7326ea0296690f89416d7e32ddba"
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
    ]

    # JIT not currently supported for Apple Silicon
    args << "--enable-jit" unless Hardware::CPU.arm?

    system "./autogen.sh" if build.head?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"pcre2grep", "regular expression", prefix/"README"
  end
end
