class Libsm < Formula
  desc "X.Org: X Session Management Library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libSM-1.2.6.tar.xz"
  sha256 "be7c0abdb15cbfd29ac62573c1c82e877f9d4047ad15321e7ea97d1e43d835be"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ddab9c6da4ddc8c83f79079c63d16f220701ad058c8c8a07b077ceaed3eb7d3"
    sha256 cellar: :any,                 arm64_sequoia: "fcfe468b583f69a170f81760d0b4f3c87c60fcfaa4e3b572cda227ccee5dc255"
    sha256 cellar: :any,                 arm64_sonoma:  "8667f1d54feeb12d392f9347e8d9bf18dea2a55fe65a2740ae58ab579b192128"
    sha256 cellar: :any,                 arm64_ventura: "3175340d660c4b58e19c9625cef2479ba0e5b10f73a9f9afc433deb2f46710e0"
    sha256 cellar: :any,                 sonoma:        "4b4f15ad71a83a96941c9162bd1fedbaa2889c14558bee37198e8e6c30acb743"
    sha256 cellar: :any,                 ventura:       "a06561a9dee2db28337b87ac73fdf1ea55a88c31b3b98534e350b3feeb4c74c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94ce571df236e9e1d56c3dce8055e0d5c4755eddad55646c263c95505ac07ad2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f1cb49ab246f356b91a633720a6043f3817b654f2933ed72445b2ab2c20a91e"
  end

  depends_on "pkgconf" => :build
  depends_on "xtrans" => :build
  depends_on "libice"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      --enable-docs=no
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/SM/SMlib.h"

      int main(int argc, char* argv[]) {
        SmProp prop;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
