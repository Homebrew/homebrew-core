class Npth < Formula
  desc "New GNU portable threads library"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/npth/npth-1.6.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/npth/npth-1.6.tar.bz2"
  sha256 "1393abd9adcf0762d34798dc34fdcf4d0d22a8410721e76f1e3afcd1daa4e2d1"

  bottle do
    cellar :any
    sha256 "ecb35292b1cbcf24e42f9dd0691dc9030345e8b8b1b7f9c9a865fca2fb25932c" => :catalina
    sha256 "bb0232908eedb717f98d636b910478ef4ce044866545725344ecae0b85251e1d" => :mojave
    sha256 "51a68f02a29f9b1a596048894be6425696872ddbbc928b372c07a5e256df8ba8" => :high_sierra
    sha256 "930defbdfa6136f82abdaa7efea0328390079d13f284798756997217eb31427d" => :sierra
    sha256 "8b2591ec804a0e410e8bf8657487f2d26248307e7cf74b2e49906037618ebc03" => :el_capitan
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
