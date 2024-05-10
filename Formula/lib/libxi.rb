class Libxi < Formula
  desc "X.Org: Library for the X Input Extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXi-1.8.1.tar.xz"
  sha256 "89bfc0e814f288f784202e6e5f9b362b788ccecdeb078670145eacd8749656a7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "186b0d80090bbcbe912168c06c621a42ff3f86662fa653b6ad861aade19f3094"
    sha256 cellar: :any,                 arm64_ventura:  "d9872dfea9740864368289b3e9504791e9bf97708f449a995d7b0d1187f66517"
    sha256 cellar: :any,                 arm64_monterey: "b742ea6b45f382da3f9524251def162289e76c8d384ea403b10fcedce4bc9fbc"
    sha256 cellar: :any,                 arm64_big_sur:  "a7461ee9844534605737df8f938d44cc020af20d8c670474babf724b906bae3e"
    sha256 cellar: :any,                 sonoma:         "faeb7c8b736fc014efdec6324a7b6441d03535ebf7bedb62345df6347cd1a3ab"
    sha256 cellar: :any,                 ventura:        "7b3506e3d213cc91362a9b97f8644d0c5084f963b09c1d9e76cb733374f0e042"
    sha256 cellar: :any,                 monterey:       "8210bc106281f5968af71d7662a561900f2cece88359ccbb69f76a75622c5a38"
    sha256 cellar: :any,                 big_sur:        "e5e10d66401669290a849a513fc4458c6e0fcdd98fac4c233d65354823c384e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20968fad8ac9363d24305ed0e4133f9e004e84966b2cee96b227eb2b1f1af1ad"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxfixes"
  depends_on "xorgproto"

  conflicts_with "libslax", because: "both install `libxi.a`"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-docs=no
      --enable-specs=no
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/extensions/XInput.h"

      int main(int argc, char* argv[]) {
        XDeviceButtonEvent event;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
