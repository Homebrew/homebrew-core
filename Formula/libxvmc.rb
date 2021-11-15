class Libxvmc < Formula
  desc "X.Org: X-Video Motion Compensation API"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXvMC-1.0.12.tar.bz2"
  sha256 "6b3da7977b3f7eaf4f0ac6470ab1e562298d82c4e79077765787963ab7966dcd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "58c6c762facb2bdabf3f5acd0fe77365065750b6ecf19df17fccafc8683343ab"
    sha256 cellar: :any,                 arm64_big_sur:  "32885178eaa7d79ea1002cd23e9f2a1552a6cd3636b33863e101b3fd94bef57a"
    sha256 cellar: :any,                 monterey:       "83a6483d57d9f5f6f56bbf951821b6629277314f3dc03659e7d1fcd135526d42"
    sha256 cellar: :any,                 big_sur:        "e6921d091fcd38b2ba85587864b3a4c2e2834fd74e985d82cfffd971c6d06ffd"
    sha256 cellar: :any,                 catalina:       "25bf67d5ac709c8a1551f38dc7da22bc5a2007b1a0d56589e96f172d35248f7e"
    sha256 cellar: :any,                 mojave:         "aa97b7fa2fa9c9a6df4cdd7bd939b2febfe870dd3feed76214d9f41789d50ab8"
    sha256 cellar: :any,                 high_sierra:    "b00b2e0ba733b3cd0ad8979cce06353e13a9474c5be32e53a467b8308b78f99a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "729af3ef393a9fe74f1dd382d940b6217fb02b52eef23f1bc41d8ee20500b06e"
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxv"

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
      #include "X11/Xlib.h"
      #include "X11/extensions/XvMClib.h"

      int main(int argc, char* argv[]) {
        XvPortID *port_id;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
