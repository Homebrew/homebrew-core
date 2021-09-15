class Liblo < Formula
  desc "Lightweight Open Sound Control implementation"
  homepage "https://liblo.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/liblo/liblo/0.31/liblo-0.31.tar.gz"
  sha256 "2b4f446e1220dcd624ecd8405248b08b7601e9a0d87a0b94730c2907dbccc750"
  license "LGPL-2.1"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "95b358e3f04623998f6c2d734599ec7e63b3c389f9d6e0cc9fc6311850929f55"
    sha256 cellar: :any,                 big_sur:       "19eef0619f05faa15a7d5368973dcd3e5ed2e44291b56cc6ff72825fe8879845"
    sha256 cellar: :any,                 catalina:      "aac4280d5e147a6baab53c252bbf7cda296fe5bdeceb26d7aa60acb10ecc5444"
    sha256 cellar: :any,                 mojave:        "3310110ec91fb412b8d5c727bda03454aebec087d78ebada20bb53ad9582088e"
    sha256 cellar: :any,                 high_sierra:   "034eaec236ee4df490d16db9998ec7a4d88223d929b333c8b08ade641bc74bcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4abab6d8b5735e6b1dac973850d9608e71c644255c13b954365398daf8aeec4"
  end

  head do
    url "https://git.code.sf.net/p/liblo/git.git", branch: "master"

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
