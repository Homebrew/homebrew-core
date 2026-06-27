class Libxi < Formula
  desc "X.Org: Library for the X Input Extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXi-1.8.3.tar.xz"
  sha256 "7ad60056f01af4f786cfe93b3a7707447711626fc8da2637bec71a90409babe5"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0caffca513b30f308fa1bd54682319f140ea0543397c3f61046f64a39ebcbe85"
    sha256 cellar: :any,                 arm64_sequoia: "b8267eff95643d75f879e222a0dee27f938bf9eac0ebd93d39abfd557a05e0e5"
    sha256 cellar: :any,                 arm64_sonoma:  "1f48d151e61ad252b4b34e7a083d7f4985969b53e32ae76e974aacc719ab18e7"
    sha256 cellar: :any,                 sonoma:        "156699bb0a014109ede563b0e056d977e00c12ee8526b051910664385dd6d522"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9eec879337fd7d374842691b2662e96c885a5b70e1d3b366ca2b139e14eb1b7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5128c5f8ad475f0115e02bd2273029d93ef90ab63dfc0bfd414cf2eb01072c89"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxfixes"
  depends_on "xorgproto"

  conflicts_with "libslax", because: "both install `libxi.a`"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      --enable-docs=no
      --enable-specs=no
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/extensions/XInput.h"

      int main(int argc, char* argv[]) {
        XDeviceButtonEvent event;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
