class Libxfixes < Formula
  desc "X.Org: Header files for the XFIXES extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXfixes-6.0.0.tar.bz2"
  sha256 "a7c1a24da53e0b46cac5aea79094b4b2257321c621b258729bc3139149245b4c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2535425bfa83ab70f55cd3ee6bbde7f1de590188f07170411d60babe976419af"
    sha256 cellar: :any, big_sur:       "614e75f3de08e9ce56d47f17a9d293ac9ddecdda1ce08567743a4d4edf03a5bf"
    sha256 cellar: :any, catalina:      "d811d1d116d0d42f53df60cbae1a9ced87580445a1bcd30005227d43a9fd23e3"
    sha256 cellar: :any, mojave:        "c784ffa191d81e4a4a0585df94ea4cff0281d813b8ae799283cd79798a769264"
    sha256 cellar: :any, high_sierra:   "c41141d2f1965ebbdfaea27c0f316fe472e8302dd70beb026bcb5b607dbd6db0"
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
