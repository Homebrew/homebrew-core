class Libxaw < Formula
  desc "X.Org: X Athena Widget Set"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXaw-1.0.16.tar.xz"
  sha256 "731d572b54c708f81e197a6afa8016918e2e06dfd3025e066ca642a5b8c39c8f"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "1eb007237abefeeabfb2b323354f9957397246e68844e809adfee5c7dce09dda"
    sha256 arm64_ventura:  "2f50b6cc646acb42a872a5a38a10593260707745d1bf6676d8b5faafb090fef1"
    sha256 arm64_monterey: "d1c2869ccf78f6ab5dc970d342a22c91cc0f69c9afb44ced6c32aff15452bbdf"
    sha256 arm64_big_sur:  "602e6f3f98d4bfb01422314291a118b8aed7bae9eafbe174151d3e28dc243d8b"
    sha256 sonoma:         "a5824411f19db20ce488278b0e720849273b1d205a8c810e1b45beb981097d1f"
    sha256 ventura:        "3082797341c7d9eab63f938c99c1453de273564ef74f5344a10caaa8bb3616c1"
    sha256 monterey:       "a2a933c8ff1e3067523d84605b2a718e87d134356fdbadab94d8c3ff7670299c"
    sha256 big_sur:        "ab588cbedfc53ac1194850d79d03e4f064f3cb5fe05789a65042fec7ce844cac"
    sha256 x86_64_linux:   "ffa6f160d4cb2245d012676893e5c61396d72fb7d2233f9864a8bbdb3175564e"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxmu"
  depends_on "libxpm"
  depends_on "libxt"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      --enable-specs=no
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/Xaw/Text.h"

      int main(int argc, char* argv[]) {
        XawTextScrollMode mode;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
