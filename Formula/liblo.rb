class Liblo < Formula
  desc "Lightweight Open Sound Control implementation"
  homepage "https://liblo.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/liblo/liblo/0.31/liblo-0.31.tar.gz"
  sha256 "2b4f446e1220dcd624ecd8405248b08b7601e9a0d87a0b94730c2907dbccc750"

  bottle do
    cellar :any
    sha256 "aac4280d5e147a6baab53c252bbf7cda296fe5bdeceb26d7aa60acb10ecc5444" => :catalina
    sha256 "3310110ec91fb412b8d5c727bda03454aebec087d78ebada20bb53ad9582088e" => :mojave
    sha256 "034eaec236ee4df490d16db9998ec7a4d88223d929b333c8b08ade641bc74bcb" => :high_sierra
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
