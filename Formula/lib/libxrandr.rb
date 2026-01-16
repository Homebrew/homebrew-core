class Libxrandr < Formula
  desc "X.Org: X Resize, Rotate and Reflection extension library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXrandr-1.5.4.tar.xz"
  sha256 "1ad5b065375f4a85915aa60611cc6407c060492a214d7f9daf214be752c3b4d3"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "5786e3a7fe8620155141375bded4c2f6c7ec24149a7bdcca18db40fa3607c34c"
    sha256 cellar: :any,                 arm64_sequoia:  "e29fec5331c2d36188093a2331d0f2f426c9cb18d21e5335931ee0d0e22e5ec9"
    sha256 cellar: :any,                 arm64_sonoma:   "7775fef1d482d55d108a57bd2cc32c3177eea7270956a2fb648b3683acd54049"
    sha256 cellar: :any,                 arm64_ventura:  "dbc964894d888cc4147af5ca01528a8bfaacff3c9219981267c405bd37e591de"
    sha256 cellar: :any,                 arm64_monterey: "e19d7b1164d1aacee9a9a9f2811f5071fdb649913f3b6a388b11ab56ba65c153"
    sha256 cellar: :any,                 sonoma:         "c400393add3a4dab2a9be13192af2cafdf443234c527a57bb9e22ecfa28cb019"
    sha256 cellar: :any,                 ventura:        "1cd8ea19e0bdef49383720d3d4aa1c639981a36c9c0a2763c1e9b73afe6a9f06"
    sha256 cellar: :any,                 monterey:       "52f7889369a183269ec67a15b65bc4bdc41fb5209bc4d291fb7c91abb5455319"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5d5d28081dd9152f7866682e673bf2cc425a0d0bdcfc8917ad54edcad5d1bbed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c48b622aed3d5e99e225601dca2d129fda08585571d948f8737f3e6a4bcb2a56"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxrender"
  depends_on "xorgproto"

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
      #include "X11/Xlib.h"
      #include "X11/extensions/Xrandr.h"

      int main(int argc, char* argv[]) {
        XRRScreenSize size;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
