class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "https://www.pcre.org/"
  url "https://ftp.pcre.org/pub/pcre/pcre2-10.36.tar.bz2"
  sha256 "a9ef39278113542968c7c73a31cfcb81aca1faa64690f400b907e8ab6b4a665c"
  license "BSD-3-Clause"
  head "svn://vcs.exim.org/pcre2/code/trunk"

  livecheck do
    url "https://ftp.pcre.org/pub/pcre/"
    regex(/href=.*?pcre2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "b2edbffaf229fc490843e83b43c4e12feab906fc34270d928c59cac74c6f4536" => :big_sur
    sha256 "8160558f322198cb735708ca993a683594d6f9dc83112cc26a378be466133edc" => :arm64_big_sur
    sha256 "d14484c7e5d4a74112474288bb2b2edff55be51a42fd65dd02d046d24ebb6cd7" => :catalina
    sha256 "2b16cf051af3ba797d12818e209ddbcafcd007e9af6474c0a642d388e299be90" => :mojave
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
