class Libxxf86vm < Formula
  desc "X.Org: XFree86-VidMode X extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXxf86vm-1.1.7.tar.gz"
  sha256 "9a983e3cbb7a57905262291a17da962293c0645f99efd475e3c85264bfddc337"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eecafb9b9780c7af7c07b4f50393d44a2b0f068bbdf7dfa1cfb1a8ada5362729"
    sha256 cellar: :any,                 arm64_sequoia: "bfb2f2dd1b5ee926cfb5912987e32050f4859e63b25643c5143c4a77fca3425f"
    sha256 cellar: :any,                 arm64_sonoma:  "605aac8e796069b46a0e60e963764ed4822da08fd3ef024ed6a8edca139139ba"
    sha256 cellar: :any,                 sonoma:        "cdde3acf54e35e37cd9db3fd9dfb8068803d9fc447ffc0b51de8cadd29f45a9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b0fa1889b9360a9b0cb8f7a5bac5a5842366d34701d1ae217b29a2794c4d7dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad19e4a6ab9d92b97a090b9a5f725d23dca70095cc79e62d6134d7afec7407e3"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "libxext"
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
      #include "X11/extensions/xf86vmode.h"

      int main(int argc, char* argv[]) {
        XF86VidModeModeInfo mode;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
