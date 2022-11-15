class Libxext < Formula
  desc "X.Org: Library for common extensions to the X11 protocol"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXext-1.3.5.tar.gz"
  sha256 "1a3dcda154f803be0285b46c9338515804b874b5ccc7a2b769ab7fd76f1035bd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "36ef5333565be1614ad8eb2d740ea93df80c5d2ee41b403145179e7c5d1e1e82"
    sha256 cellar: :any,                 arm64_monterey: "4f194ef26f45585047eab4ceaa2c811c4273d32d2ea47d9b3d18f09bb0c1f300"
    sha256 cellar: :any,                 arm64_big_sur:  "232f1d192c14de36a9cb57dfedd73943d65fdd6ce3b75e80d4d0c2eb6c18dcd6"
    sha256 cellar: :any,                 ventura:        "8567d6ebc49a8efcda5216368ba27ed2493bb4bb00492b66ba9e1686cee17c61"
    sha256 cellar: :any,                 monterey:       "9682e4720a940f352af2cea9e4633cdf14947e23b640bac524e1b3674b9493a9"
    sha256 cellar: :any,                 big_sur:        "674376b0e5cbcfb9278cdcf97e4ccc3910bf134cb1e45bf9e190d614a7f3a200"
    sha256 cellar: :any,                 catalina:       "77862d3344c49f5bc3bf77f3efeaff99d36330bf13cb05c91cf7a4f4d43ed7a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5e6ada73c0d137a611ca58038a36227f3ac10e59986b9bf9da21e2a44bdaab2"
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
