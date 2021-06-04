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
    sha256 cellar: :any, arm64_big_sur: "7bdcd1b4fa7a511b2c4250033a65508aa1b7ea43d8379946a96fd496e5d401fc"
    sha256 cellar: :any, big_sur:       "981738c8279de442ac2fc83fa61e9cdf75e5c26b19a6d7fc2179362da2d522f7"
    sha256 cellar: :any, catalina:      "6ab918e130104bc0c4155e1d25e9691e542703071f1b48c41cc123605e3558ff"
    sha256 cellar: :any, mojave:        "2b0ec328faea65cfa6466fb9cf1eb6a081dd5046decc31e448e81966bbacf87b"
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
