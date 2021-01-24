class Libxt < Formula
  desc "X.Org: X Toolkit Intrinsics library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXt-1.2.1.tar.bz2"
  sha256 "679cc08f1646dbd27f5e48ffe8dd49406102937109130caab02ca32c083a3d60"
  license "MIT"

  bottle do
    cellar :any
    sha256 "a70e54d9374444cbc8e1ed592ccd24de3120854efb3248085db261411d318058" => :big_sur
    sha256 "01c92a3915f414ec9880723e6c2928a33bea584ca5c1d1f38f67e001920ecded" => :arm64_big_sur
    sha256 "6b454a895e68fb652f1b54aaa4cdefa9282465d5bc4f6dbebd5fc499fea6a7d1" => :catalina
    sha256 "c4522922f276b72a5ba605b80ca188ae8808d5f5d4cb0de8f4d0639669bd6232" => :mojave
    sha256 "a68f79946b3061006f1b59c6b63f1dfc2f72565a15a05c6b91b1165946f952aa" => :high_sierra
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
