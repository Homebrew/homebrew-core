class Libxrandr < Formula
  desc "X.Org: X Resize, Rotate and Reflection extension library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXrandr-1.5.3.tar.xz"
  sha256 "897639014a78e1497704d669c5dd5682d721931a4452c89a7ba62676064eb428"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ec2edecbeb989b084cddf73999f12012a7e6d35b4bf8fc7b4942c9bd75d29874"
    sha256 cellar: :any,                 arm64_ventura:  "5ea5208202568e3a5f5a3eb3579b4f84d4647d709fd4561c4609ef76ede3e142"
    sha256 cellar: :any,                 arm64_monterey: "5a214860d36c942af75d82cf048a0eb4f2f7755c07324228061c76d5724a6af0"
    sha256 cellar: :any,                 arm64_big_sur:  "c585a075f6ca7b9c8354add75f91febfaea41e8ad4e30d95f4346e85b030cb0d"
    sha256 cellar: :any,                 sonoma:         "db11caab887e57fa954e28f31fc04a83286cbddf59c1576639d65cebd9ab6710"
    sha256 cellar: :any,                 ventura:        "7d7e72a894fdc4d9186dcb57d27c47ec2fbfa2eb7d1c74b8161069916024608a"
    sha256 cellar: :any,                 monterey:       "c48003fc31825241aa4b1a11d50c46cc8612b21bbfafda13291d0711a2871565"
    sha256 cellar: :any,                 big_sur:        "67863dc0475ed650a5d84241249d05a5cbe537d06cde9b6f02c35efc998a3bea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9668078fec4152c27d10e6135985209e42a831aecf3c18aaaaf59f0af2450836"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxrender"
  depends_on "xorgproto"

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
      #include "X11/extensions/Xrandr.h"

      int main(int argc, char* argv[]) {
        XRRScreenSize size;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
