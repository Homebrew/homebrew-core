class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "https://www.pcre.org/"
  url "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.40/pcre2-10.40.tar.bz2"
  sha256 "14e4b83c4783933dc17e964318e6324f7cae1bc75d8f3c79bc6969f00c159d68"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^pcre2[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "18b810bc5ddba9960505488662ad3b122c898ded44461e2dfb871ee32abbe0fb"
    sha256 cellar: :any,                 arm64_big_sur:  "e9ad944caf659a16e81a3232da8b9d21547b9979cc784f9d242860667ed757a5"
    sha256 cellar: :any,                 monterey:       "3d2707e8d5a80e1a28875e3b9c7b47cebaf5fd420049d6f1a72fa933b0e68339"
    sha256 cellar: :any,                 big_sur:        "0108a261b51c0c8628eb94fb92a00e33867dccac8b6756a71a24e47f596125c7"
    sha256 cellar: :any,                 catalina:       "b25728793286a5fcd8a92d4a75033e20df74c60ffe1d5d886ea5ad719fe25927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3b73a0c4061aefa98f11f9dfa6c10aadcbdb105a9328d3d66b64e76b9b0538b"
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
