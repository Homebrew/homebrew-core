class Libxres < Formula
  desc "X.Org: X-Resource extension client library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXres-1.2.2.tar.xz"
  sha256 "9a7446f3484b9b7538ac5ee30d2c1ce9e5b7fbbaf1440e02f6cca186a1fa745f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e7f72b305f5c62fa3bd025cb437a533e0d5fd903bbf165d8b86f0e19e163474a"
    sha256 cellar: :any,                 arm64_sonoma:   "d75dbe208195822aa95957e8037d80dec8c5c86c60a5669afb7ec2187210d64b"
    sha256 cellar: :any,                 arm64_ventura:  "fbf27991234578c082292975c64ee98b2ab2b69dd2cbc71056dfb3c2fd94ffb9"
    sha256 cellar: :any,                 arm64_monterey: "e3fa4b14265315d1dd48439e241df505cef320c6a25a33a91e58e2245bb2f203"
    sha256 cellar: :any,                 arm64_big_sur:  "cb39d8ae314b09357fbaadbcbb14abb7a21e85bb4d298a3e2efe2bd411a21fe9"
    sha256 cellar: :any,                 sonoma:         "f13a56fa17a6818add007ee90aebe57911fa824dda047d836169ce241873b6c3"
    sha256 cellar: :any,                 ventura:        "7ba9d4daab9d3636b53d98510309eb2c37dd07ba9efd5585947d1e3609067388"
    sha256 cellar: :any,                 monterey:       "ab7139ca0d7d8b12508d9211704963ff34d8b62a3888b222018c76dad8702280"
    sha256 cellar: :any,                 big_sur:        "6dfe38b8542221db4841c3326d2c647894b7a86b45cae7b82ee83e95105ec150"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d4c512a727a4d313ed53f32bf7d7aabc96e0ef445b1a56a175ec3381dcbb1ef7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0a84c746909317e32b8e527e20d56df64836bf461e8719d5bbab2be1f249cc0"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build
  depends_on "libx11"
  depends_on "libxext"

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
      #include "X11/extensions/XRes.h"

      int main(int argc, char* argv[]) {
        XResType client;
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lXRes"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
