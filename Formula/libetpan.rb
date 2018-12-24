class Libetpan < Formula
  desc "Portable mail library handling several protocols"
  homepage "https://www.etpan.org/libetpan.html"
  url "https://github.com/dinhviethoa/libetpan/archive/1.9.2.tar.gz"
  sha256 "45a3bef81ae1818b8feb67cd1f016e774247d7b03804d162196e5071c82304ab"

  bottle do
    cellar :any
    sha256 "dd099ac0345f5af0c75baa8203e7cbab1199e57e5db148094d8ab1e09a9cfe9a" => :mojave
    sha256 "22bc38a732865ba07d68410ee7d99d237d1db87aceaecb084fb7cf6e46681ba8" => :high_sierra
    sha256 "30eafeadf05274390a3416fe11d852410907b3d61c4d0fe171e03fa5f86df136" => :sierra
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
    (testpath/"test.c").write <<~EOS
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
