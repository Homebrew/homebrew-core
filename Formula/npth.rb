class Npth < Formula
  desc "New GNU portable threads library"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/npth/npth-1.6.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/npth/npth-1.6.tar.bz2"
  sha256 "1393abd9adcf0762d34798dc34fdcf4d0d22a8410721e76f1e3afcd1daa4e2d1"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/npth/"
    regex(/href=.*?npth[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "42b7dba6d77de24f051ef7535f57fd818fa89c7baf7775058d4628efd7f6e524"
    sha256 cellar: :any,                 arm64_monterey: "b57db2aba825a5f895e946878002f81d307a1b2cdf60c18ac8d70860321eb5d6"
    sha256 cellar: :any,                 arm64_big_sur:  "17c2bebc1b58d15726610a97771d156f4b6bf723d6b2d205c53744bed8024c7d"
    sha256 cellar: :any,                 ventura:        "e818fff59d3a659e190846d750fb3ca075e8215b62027deeca8f04961260f720"
    sha256 cellar: :any,                 monterey:       "32f94bbca4712732758698b0e50ccac4fdcef51e0ddde1182f2c8740d0e22a33"
    sha256 cellar: :any,                 big_sur:        "dde67b8b6f6ad244e560de1d041864a7f35a89c252447a5b9aedec52ac6ba3ac"
    sha256 cellar: :any,                 catalina:       "ecb35292b1cbcf24e42f9dd0691dc9030345e8b8b1b7f9c9a865fca2fb25932c"
    sha256 cellar: :any,                 mojave:         "bb0232908eedb717f98d636b910478ef4ce044866545725344ecae0b85251e1d"
    sha256 cellar: :any,                 high_sierra:    "51a68f02a29f9b1a596048894be6425696872ddbbc928b372c07a5e256df8ba8"
    sha256 cellar: :any,                 sierra:         "930defbdfa6136f82abdaa7efea0328390079d13f284798756997217eb31427d"
    sha256 cellar: :any,                 el_capitan:     "8b2591ec804a0e410e8bf8657487f2d26248307e7cf74b2e49906037618ebc03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04d83373d7eb4a417d127c7e341e0de0cdd154b876097c124dab3b83ada2fc9e"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/npth-config", "--version"
  end
end
