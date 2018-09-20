class Libetpan < Formula
  desc "Portable mail library handling several protocols"
  homepage "https://www.etpan.org/libetpan.html"
  url "https://github.com/dinhviethoa/libetpan/archive/1.9.1.tar.gz"
  sha256 "f5e354ccf1014c6ee313ade1009b8a82f28043d2504655e388bb4c1328700fcd"

  bottle do
    cellar :any
    sha256 "129de40c12f55e12014cba838c53d5ad70893fb3bc61e44f379312cd4dc83fa7" => :mojave
    sha256 "f0e48605c71498c3655f05198a78d1cf3862fb8b58a9ddba63c0720e623fc874" => :high_sierra
    sha256 "b4ed998765fdeb1d06bdd1e4dce6328db77fafd88f932f1fc087639ce3e668db" => :sierra
    sha256 "f9d56b936577471d9689a30a7c126a44416a4be26a42300244a29202b9abdccf" => :el_capitan
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
