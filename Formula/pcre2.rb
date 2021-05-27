class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "https://www.pcre.org/"
  url "https://ftp.pcre.org/pub/pcre/pcre2-10.37.tar.bz2"
  sha256 "4d95a96e8b80529893b4562be12648d798b957b1ba1aae39606bbc2ab956d270"
  license "BSD-3-Clause"
  head "svn://vcs.exim.org/pcre2/code/trunk"

  livecheck do
    url "https://ftp.pcre.org/pub/pcre/"
    regex(/href=.*?pcre2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8160558f322198cb735708ca993a683594d6f9dc83112cc26a378be466133edc"
    sha256 cellar: :any, big_sur:       "b2edbffaf229fc490843e83b43c4e12feab906fc34270d928c59cac74c6f4536"
    sha256 cellar: :any, catalina:      "d14484c7e5d4a74112474288bb2b2edff55be51a42fd65dd02d046d24ebb6cd7"
    sha256 cellar: :any, mojave:        "2b16cf051af3ba797d12818e209ddbcafcd007e9af6474c0a642d388e299be90"
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

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"pcre2grep", "regular expression", prefix/"README"
  end
end
