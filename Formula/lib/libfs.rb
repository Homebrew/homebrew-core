class Libfs < Formula
  desc "X.Org: X Font Service client library"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libFS-1.0.10.tar.gz"
  sha256 "38daddf6aaad25d93c6ff762c9629b8f10b19e8c4b70fcf117ec38c440ff9ae2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "94998e85015760c70264600b4e416ba64da6b45c335abf732a5e4152868d06d6"
    sha256 cellar: :any,                 arm64_sequoia:  "f6fa56b30b3705449138f8afb6ad4e4fcb67ade47f95e0ac73147c2c14f5a800"
    sha256 cellar: :any,                 arm64_sonoma:   "861860b63988d0167eebf30e0ec648471f880b3d4aba8ca48dc66c4532027826"
    sha256 cellar: :any,                 arm64_ventura:  "1536673a3015c07c20e3d0a49d8f752e61e5ea90f196d0a11212f68b06021598"
    sha256 cellar: :any,                 arm64_monterey: "0fbbf2d8e77fec93a9c21cc94f7f0f1be3c9880bab4fb5da49e8b4afdfaf9821"
    sha256 cellar: :any,                 sonoma:         "1ea2f6712729fd699ea40714c86ef74c3126404df219122c38ea18b1ce03a6e0"
    sha256 cellar: :any,                 ventura:        "015e40efae665280299a9fef6e282e18cf16c47896bc7c0829d9fe3dd578d246"
    sha256 cellar: :any,                 monterey:       "2a035cdd2ef46765aece7a6f30e82d19d92e135841d74bca444c9b1d8d0a98e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a0bc3bc73b7eeffd71ca62f12e9ff99684362f82ade1606e7646da3926013e4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c17d8ae2548594b5aae02734f0c2804858754e00f2e1b2dcc38d5bc86086aa5e"
  end

  depends_on "pkgconf" => :build
  depends_on "xtrans" => :build
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
      #include "X11/fonts/FSlib.h"

      int main(int argc, char* argv[]) {
        FSExtData data;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
