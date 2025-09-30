class Libfontenc < Formula
  desc "X.Org: Font encoding library"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libfontenc-1.1.8.tar.xz"
  sha256 "7b02c3d405236e0d86806b1de9d6868fe60c313628b38350b032914aa4fd14c6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "badff62bd95618002e7da104527ef4d9f6cd09c7fc285ffb5fc2d519b0e2e7ac"
    sha256 cellar: :any,                 arm64_sequoia:  "5e4228d360d809601a62a880d67db005d4a9d3a92ddfbf47e6c6d0154f258bcd"
    sha256 cellar: :any,                 arm64_sonoma:   "67887ebe92518e43424e8b468b310fde9ab42d9791d387d59519cdbfb4a2f43c"
    sha256 cellar: :any,                 arm64_ventura:  "15cec1b1e8ca8856aa59de28068cd187831281b1376597d7bb87c5f79b80e10c"
    sha256 cellar: :any,                 arm64_monterey: "129b929cf9305162d58922cce06530c4c1da2968adc292503240105c454bae67"
    sha256 cellar: :any,                 sonoma:         "bddef82fa135b48fa58485df06f80aeda327ac2e77a4fdb05d3543135c123692"
    sha256 cellar: :any,                 ventura:        "ce1f99b92616293e816e6d04918e1570ff18ed052ba6cdcb66115ceee37d9240"
    sha256 cellar: :any,                 monterey:       "4f2d62d14136a1c6ca9e4f01d1b1bf454c9e90bc6eb3f50e6bff76a631ac0621"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "484aac796b8b64a4cf00668a052c6734851f54de232c684a48255245bf7898f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f29d93ac7c98c61ac6e50b6d057bac244b13eb52046af1634ee623f452b1c5e"
  end

  depends_on "font-util" => :build
  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build

  uses_from_macos "zlib"

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
      #include "X11/fonts/fontenc.h"

      int main(int argc, char* argv[]) {
        FontMapRec rec;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
