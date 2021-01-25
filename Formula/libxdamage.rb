class Libxdamage < Formula
  desc "X.Org: X Damage Extension library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXdamage-1.1.5.tar.bz2"
  sha256 "b734068643cac3b5f3d2c8279dd366b5bf28c7219d9e9d8717e1383995e0ea45"
  license "MIT"

  bottle do
    cellar :any
    sha256 "68750157664e1290e30b15ad95dbfcc1be2748b85e7eaef0851f2c0f56f043e3" => :big_sur
    sha256 "bbd5ef8f7408de369198e66bc6aa8a75ddc798c444ebd7f03b885bc25ccfb136" => :arm64_big_sur
    sha256 "2c09f29dfafe280bc0179dfe6ad82b623459e6bec07fefac41cf6b3e52385100" => :catalina
    sha256 "ea0aee131addc90c4b4ba6e0d8c4f8cdfd39dc034a7bfc3e841c408042ad8906" => :mojave
    sha256 "5c0ca5debb8c99cfed432fa2299e4a280ca81f8988aaacf44e0c0194d89ca7ac" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxfixes"
  depends_on "xorgproto"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/extensions/Xdamage.h"

      int main(int argc, char* argv[]) {
        XDamageNotifyEvent event;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
