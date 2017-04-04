class Libetpan < Formula
  desc "Portable mail library handling several protocols"
  homepage "https://www.etpan.org/libetpan.html"
  url "https://github.com/dinhviethoa/libetpan/archive/1.7.2.tar.gz"
  sha256 "32797282a420f3174f4a679548e20fa2bb4acb404b827d62c2f44d3de4eb3120"

  bottle do
    cellar :any
    sha256 "94cc08e216d7ca5a4f577552fe19ec39af7a745a929066ab0621be8a80a89d59" => :sierra
    sha256 "6d72ad120e536d14e36d2b611aebbe1d2fdfce4a5add1f2f9e5ac93033711c08" => :el_capitan
    sha256 "4771e7ee609e72acee24d1f351930af44045bb980f6a3230f69623bbc7b43e8b" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh", "--disable-debug",
                           "--disable-dependency-tracking",
                           "--disable-silent-rules",
                           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <libetpan/libetpan.h>
      #include <string.h>
      #include <stdlib.h>

      int main(int argc, char ** argv)
      {
        printf("version is %d.%d",libetpan_get_version_major(), libetpan_get_version_minor());
      }
      EOS
    system ENV.cc, "test.c", "-L#{lib}", "-letpan", "-o", "test"
    system "./test"
  end
end
