class Libxext < Formula
  desc "X.Org: Library for common extensions to the X11 protocol"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXext-1.3.4.tar.bz2"
  sha256 "59ad6fcce98deaecc14d39a672cf218ca37aba617c9a0f691cac3bcd28edf82b"
  license "MIT"

  bottle do
    cellar :any
    sha256 "8a037408ba5c4c95c33af0d022edd631b744823bb9fa522a06b502ed9bf1fbc5" => :big_sur
    sha256 "24e44ef107138f015271fcd5aaa400403594adf7c64cf4a628b0cfe44d4e9fc6" => :arm64_big_sur
    sha256 "20cc49734eba43e2e9f058fa12f3782c76ac232fada3f6d297f91dca6e0582be" => :catalina
    sha256 "3f2da07d877e158f41231d088f0ffe5551132beaf2f3df683dae0ac2c11817cb" => :mojave
    sha256 "0070b8ea70006d011aac1c617e1a5f88caa2ae351b637858f828f859cb72d813" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "xorgproto"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-specs=no
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/extensions/shape.h"

      int main(int argc, char* argv[]) {
        XShapeEvent event;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
