class Libxt < Formula
  desc "X.Org: X Toolkit Intrinsics library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXt-1.2.1.tar.bz2"
  sha256 "679cc08f1646dbd27f5e48ffe8dd49406102937109130caab02ca32c083a3d60"
  license "MIT"

  bottle do
    cellar :any
    sha256 "db76d4efdf96e00af7b4230245b81c26539b4ec20e93c1d379a3c92b39217885" => :big_sur
    sha256 "0fd900ad5097946ee343ba7c15311a3b85540dcd058233e05f198c15405b9da0" => :arm64_big_sur
    sha256 "a1bcc92d37e1602ef760fecb79f7729db7e38aee2835879689596d478480217b" => :catalina
    sha256 "4bd6052344cc12c674d40f44c31083264f5ce097ec0d2f6111e726862a8a2b04" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-appdefaultdir=#{etc}/X11/app-defaults
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
      #include "X11/IntrinsicP.h"
      #include "X11/CoreP.h"

      int main(int argc, char* argv[]) {
        CoreClassPart *range;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
