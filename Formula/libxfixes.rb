class Libxfixes < Formula
  desc "X.Org: Header files for the XFIXES extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXfixes-5.0.3.tar.bz2"
  sha256 "de1cd33aff226e08cefd0e6759341c2c8e8c9faf8ce9ac6ec38d43e287b22ad6"
  license "MIT"

  bottle do
    cellar :any
    sha256 "614e75f3de08e9ce56d47f17a9d293ac9ddecdda1ce08567743a4d4edf03a5bf" => :big_sur
    sha256 "2535425bfa83ab70f55cd3ee6bbde7f1de590188f07170411d60babe976419af" => :arm64_big_sur
    sha256 "d811d1d116d0d42f53df60cbae1a9ced87580445a1bcd30005227d43a9fd23e3" => :catalina
    sha256 "c784ffa191d81e4a4a0585df94ea4cff0281d813b8ae799283cd79798a769264" => :mojave
    sha256 "c41141d2f1965ebbdfaea27c0f316fe472e8302dd70beb026bcb5b607dbd6db0" => :high_sierra
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
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/extensions/Xfixes.h"

      int main(int argc, char* argv[]) {
        XFixesSelectionNotifyEvent event;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
