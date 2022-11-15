class Libfontenc < Formula
  desc "X.Org: Font encoding library"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libfontenc-1.1.6.tar.gz"
  sha256 "c103543a47ce5c0200fb1867f32df5e754a7c3ef575bf1fe72187117eac22a53"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d1b8cf545526a2343a90301bc99fd064c988540a2e1f72b5f3b73486120c5d39"
    sha256 cellar: :any,                 arm64_monterey: "fd6ca003c32ee186b3199a4332493e80956c468f0e7d5ef6b6bdff4e6aad70c9"
    sha256 cellar: :any,                 arm64_big_sur:  "1f3e16eef91a65b13d837553cfadd609a94a22d195b2029ea611c4cc1c0e71ef"
    sha256 cellar: :any,                 ventura:        "9f114ffbe9fe24cd47b2b2d34cd8f757222e3c1b941ffe5d30c90ba4ab0c5bd6"
    sha256 cellar: :any,                 monterey:       "533f627074074eb9ab19bd42cd86a28cbd1a8f57964de8085ccf4d0f12038331"
    sha256 cellar: :any,                 big_sur:        "c99e2c4fbffc3c5898634653c8bf14dd8e56735da362209627ed5c9fa3535be8"
    sha256 cellar: :any,                 catalina:       "c53a90daba5b5002e2cbfa1cf0fff9968831a2f763f1d154d20a8427c44741e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb72440ab4482cfdaefac8e0951ac451634e53d4e998f6f74495e847a7e5f9f2"
  end

  depends_on "font-util" => :build
  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build

  uses_from_macos "zlib"

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
      #include "X11/fonts/fontenc.h"

      int main(int argc, char* argv[]) {
        FontMapRec rec;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
