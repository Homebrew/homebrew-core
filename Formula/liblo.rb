class Liblo < Formula
  desc "Lightweight Open Sound Control implementation"
  homepage "https://liblo.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/liblo/liblo/0.31/liblo-0.31.tar.gz"
  sha256 "2b4f446e1220dcd624ecd8405248b08b7601e9a0d87a0b94730c2907dbccc750"

  bottle do
    cellar :any
    sha256 "f87426829c595b95559f0efba6fae738f6fbc3995cb4223a9946d18509c7c89a" => :catalina
    sha256 "bec4aa8cf37050f2b35123d1ca894801e5ae75d95034e7ee2d3b365922180332" => :mojave
    sha256 "e69e5f3405e2c55b25864a62dcdd3d454c9e460fe54d87447a1821973f9a6e67" => :high_sierra
    sha256 "c39875452da500b334cb532d903c284b178cb3f9dd15e0201228dfbe78511985" => :sierra
  end

  head do
    url "https://git.code.sf.net/p/liblo/git.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    (testpath/"lo_version.c").write <<~EOS
      #include <stdio.h>
      #include "lo/lo.h"
      int main() {
        char version[6];
        lo_version(version, 6, 0, 0, 0, 0, 0, 0, 0);
        printf("%s", version);
        return 0;
      }
    EOS
    system ENV.cc, "lo_version.c", "-I#{include}", "-L#{lib}", "-llo", "-o", "lo_version"
    lo_version = `./lo_version`
    assert_equal version.to_str, lo_version
  end
end
