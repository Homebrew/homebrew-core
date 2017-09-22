class Faad2 < Formula
  desc "ISO AAC audio decoder"
  homepage "http://www.audiocoding.com/faad2.html"
  url "https://downloads.sourceforge.net/project/faac/faad2-src/faad2-2.8.0/faad2-2.8.2.tar.gz"
  sha256 "ec836434523ccabaf2acdef0309263f4f98fb1d7c6f7fc5ec87720889557771b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7e2b3ee02f6f5b57ba65145d37d5266f01582e2eae012061204dddb905434beb" => :high_sierra
    sha256 "dc0b4f69ac5ccb338c409fbce248f2d45dae4e706ef67bb3ae4aa865c7d67b55" => :sierra
    sha256 "ded931642921a5e0d236237ce046f883aa96a0e5bfe67f5d437ee31f10b5f3d1" => :el_capitan
    sha256 "c9d4798cb9ed59d6f4b9e5fa24d65e4b9afca6a390b4e0d4168975a0da43b991" => :yosemite
    sha256 "4d5c07adef1f8fbeea4e71ad42205145b38dd3e3616485b9ee44f839c6d4f1a4" => :mavericks
    sha256 "cc0b789cd93b14247f679211b2f4a592e88395304cb6cc1df91514ed9d6a9720" => :mountain_lion
  end

  # Autotools shouldn't be required since it's a release tarball
  # Reported 22 Sep 2017 https://sourceforge.net/p/faac/bugs/224/
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc"

  # mp4read.c:253:5: error: function definition is not allowed here
  # Reported 22 Sep 2017 https://sourceforge.net/p/faac/bugs/223/
  fails_with :clang

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "infile.mp4", shell_output("#{bin}/faad -h", 1)
  end
end
