class Faad2 < Formula
  desc "ISO AAC audio decoder"
  homepage "http://www.audiocoding.com/faad2.html"
  url "https://downloads.sourceforge.net/project/faac/faad2-src/faad2-2.8.0/faad2-2.8.2.tar.gz"
  sha256 "ec836434523ccabaf2acdef0309263f4f98fb1d7c6f7fc5ec87720889557771b"

  bottle do
    cellar :any
    sha256 "3f199c08c3ee562ec2ffde6ab1e130a004956e5c3b08a3c977797b46a882716d" => :sierra
    sha256 "4febae463c234004d14143635d955862584b03e0971fefb838eebeb8324d406b" => :el_capitan
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
