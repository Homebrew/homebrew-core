class Libxfixes < Formula
  desc "X.Org: Header files for the XFIXES extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXfixes-6.0.2.tar.xz"
  sha256 "39f115d72d9c5f8111e4684164d3d68cc1fd21f9b27ff2401b08fddfc0f409ba"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "18951c8c4a266fc614d3d17798983f314230614d42184a5169d053a5d228c85c"
    sha256 cellar: :any,                 arm64_sequoia: "20bde00fb1c5b48ad54118acc702fd226efd28585e058c7ecdbff8ce8b6fb34a"
    sha256 cellar: :any,                 arm64_sonoma:  "bc6bf094a7a89a825fdd959e32df3fba8988f421b6dde86d63dc847d795becfd"
    sha256 cellar: :any,                 arm64_ventura: "c5efe52ba7a12a6c71a5706eeb9370ba5e8dd6b6b9bafb7877c0d1b9217a2ba1"
    sha256 cellar: :any,                 sonoma:        "6a4994ef8113aee2ac68b5de54b64b9b9496eafb6c30bfd9e17ed7c268e4d4d2"
    sha256 cellar: :any,                 ventura:       "c26de60861947cb51d180af89ece4acc3c807e7797ca8029e76c60bb4ed7c51c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd877255bd00d407fa7b6652d9d34abcbedff76a2c192a32e63c94add2f0b8c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f33e8a88f01a7afb5a784155e4c81051fea75570635b89ddb4b3b48d2825acf"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"
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
      #include "X11/extensions/Xfixes.h"

      int main(int argc, char* argv[]) {
        XFixesSelectionNotifyEvent event;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
