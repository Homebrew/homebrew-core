class Libfontenc < Formula
  desc "X.Org: Font encoding library"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libfontenc-1.1.10.tar.xz"
  sha256 "daa186a49e3cc2b6fc585ca09971351e6f010f618abc6a164eda82e42e4aa4d6"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c9b39562d9eebb24ca9dcb46ccc7fca6fcb8fa9f2ff9905207c240243cb18c3c"
    sha256 cellar: :any, arm64_tahoe:       "da90d84d049c0b846db3aab5dfda0b45c3f3cc230fe0f371cfaef11b82b1355c"
    sha256 cellar: :any, arm64_sequoia:     "5f88fc36263f3fe0ef0f61ab56ba58950ee5951f31213e3281fa9836987ff7ff"
    sha256 cellar: :any, arm64_linux:       "24cd45f071820125b83c9462d9d33c158347e896cb08f66dd1505c9606388c7c"
    sha256 cellar: :any, x86_64_linux:      "407d3e86eb6fcbf37dad783f63c2c9778db1a1395249d348c2e013f37324b72f"
  end

  depends_on "font-util" => :build
  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/fonts/fontenc.h"

      int main(int argc, char* argv[]) {
        FontMapRec rec;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
