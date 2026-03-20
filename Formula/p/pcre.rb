class Pcre < Formula
  desc "Perl compatible regular expressions library"
  homepage "https://www.pcre.org/"
  url "https://downloads.sourceforge.net/project/pcre/pcre/8.45/pcre-8.45.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.exim.org/pub/pcre/pcre-8.45.tar.bz2"
  sha256 "4dae6fdcd2bb0bb6c37b5f97c33c2be954da743985369cddac3546e3218bffb8"
  license "BSD-3-Clause"

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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "08de2eeaca9c98e70091c9b220f8f570b073f8db982d2451dfd35b1415aab6e6"
    sha256 cellar: :any,                 arm64_sequoia: "f04ffe5280aa77d2994ebd5ae2d9290d0b7d0471b70df18baa95ba01ae60d593"
    sha256 cellar: :any,                 arm64_sonoma:  "80fff1bcdecb1a440b001d9d880cd8aa477285af66273752464bc9f2d13b468f"
    sha256 cellar: :any,                 sonoma:        "df17d29f345822247b05d23c6faeddbac0d0a16805e6080fd67f7cffe2c54e32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0f804ff717d67d5e6ccc1457fa4378ad137dab50118f463a3a1ce24957377dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0ad29b4ac581f0b18367f131f43583b10d2fd4832d80a47e8b80364f939257d"
  end

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    args = %w[
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

    system "./configure", *args, *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "test"
    system "make", "install"
  end

  test do
    system bin/"pcregrep", "regular expression", prefix/"README"
  end
end
