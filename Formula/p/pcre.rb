class Pcre < Formula
  desc "Perl compatible regular expressions library"
  homepage "https://www.pcre.org/"
  license "BSD-3-Clause"

  stable do
    url "https://downloads.sourceforge.net/project/pcre/pcre/8.45/pcre-8.45.tar.bz2"
    mirror "https://www.mirrorservice.org/sites/ftp.exim.org/pub/pcre/pcre-8.45.tar.bz2"
    sha256 "4dae6fdcd2bb0bb6c37b5f97c33c2be954da743985369cddac3546e3218bffb8"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  # From the PCRE homepage:
  # "The older, but still widely deployed PCRE library, originally released in
  # 1997, is at version 8.45. This version of PCRE is now at end of life, and
  # is no longer being actively maintained. Version 8.45 is expected to be the
  # final release of the older PCRE library, and new projects should use PCRE2
  # instead."
  livecheck do
    skip "PCRE was declared end of life in 2021-06"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "0588ef1eb0d04ac9f4e653162bacdb5ed3e25e8f471d2b0c58e235a0a22756f6"
    sha256 cellar: :any,                 arm64_sequoia:  "50b8e2100e02a8649ac963449bf83bd8036608816b58412baad2310046d44d1f"
    sha256 cellar: :any,                 arm64_sonoma:   "fbc1ec29701c2c3f0eb750a0aecf03b90acb6d47f1bbf1dc07eb8a7c9340650e"
    sha256 cellar: :any,                 arm64_ventura:  "542a6e5dcf5f1ac6592992f949687a56515d154abf1bfdd71327edcfb5183fb6"
    sha256 cellar: :any,                 arm64_monterey: "11193fd0a113c0bb330b1c2c21ab6f40d225c1893a451bba85e8a1562b914a1c"
    sha256 cellar: :any,                 arm64_big_sur:  "2d6bfcafce9da9739e32ee433087e69a78cda3f18291350953e6ad260fefc50b"
    sha256 cellar: :any,                 sonoma:         "636ad19cc22f9c7608d5be592f8404c67458723d9629dbae026a93b8a3810e39"
    sha256 cellar: :any,                 ventura:        "df481fdd99c1dff924ea2d679623512d6c0c275e3b7c223e753ec654994ac6e5"
    sha256 cellar: :any,                 monterey:       "5e5cc7a5bf8bb6488ec57d4263bf6b0bc89e93252a0a2460f846de29373162d8"
    sha256 cellar: :any,                 big_sur:        "fb2fefbe1232706a603a6b385fc37253e5aafaf3536cb68b828ad1940b95e601"
    sha256 cellar: :any,                 catalina:       "180d88dc2230e98162685b86d00436903db4349aac701f9769997d61adb78418"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "93ad822f02719de5e91b97213d71703f9322780cc4f04c002f2f53e45fb58025"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "296026b6d5430399e40fb4f8074045a9a27d5374d83f2f6d4659c2647959f36d"
  end

  head do
    url "svn://vcs.exim.org/pcre/code/trunk"

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
      --enable-utf8
      --enable-pcre8
      --enable-pcre16
      --enable-pcre32
      --enable-unicode-properties
      --enable-pcregrep-libz
      --enable-pcregrep-libbz2
    ]

    # JIT not currently supported for Apple Silicon
    args << "--enable-jit" if OS.mac? && !Hardware::CPU.arm?

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "test"
    system "make", "install"
  end

  test do
    system bin/"pcregrep", "regular expression", prefix/"README"
  end
end
