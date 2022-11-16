class Libxi < Formula
  desc "X.Org: Library for the X Input Extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXi-1.8.tar.bz2"
  sha256 "2ed181446a61c7337576467870bc5336fc9e222a281122d96c4d39a3298bba00"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "35eee928a78657eac3d0e82a44c021a4356453b4d0446c337e6a5cfd7febec36"
    sha256 cellar: :any,                 arm64_monterey: "a65d47579981145f9c7b4225136c6e9ad7eed5268687abe7f7a8941a3a608b6c"
    sha256 cellar: :any,                 arm64_big_sur:  "44a124946d8d522eb9ef39f5ec913354e7fba982b31e46743e87fe4a9a0984ed"
    sha256 cellar: :any,                 ventura:        "28f9257656d7c7647f62f1bd65a4287627a20936313799d5ed398843f99090b7"
    sha256 cellar: :any,                 monterey:       "d43451dc55cd80dbb6ef068b60d174154240cc697c7f9929bcd3df13e315a4ba"
    sha256 cellar: :any,                 big_sur:        "29a8ae9f7812ea8ec985367dd8c3bf061bd18a689e3b3c4ff0503773263ac923"
    sha256 cellar: :any,                 catalina:       "63cc1eba03c04eda56ed89aea690805f6dbcaaa7ea82166b64d7ec5d7d7f2bc1"
    sha256 cellar: :any,                 mojave:         "11c296a17b8842fd23ca1ac58c17b3eaca8e91ecea322fc5b19eab91233ca891"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1026c8936f13ff85a1c93091cf37e488510361bdfb69d0c0ec15234a7d281ed5"
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
