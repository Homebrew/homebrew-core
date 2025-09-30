class Libdmx < Formula
  desc "X.Org: X Window System DMX (Distributed Multihead X) extension library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libdmx-1.1.5.tar.xz"
  sha256 "35a4e26a8b0b2b4fe36441dca463645c3fa52d282ac3520501a38ea942cbf74f"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "14977e0ecc11da42c82528f3c0d13d68df037f55e615ca95af6434cf214c2471"
    sha256 cellar: :any,                 arm64_sequoia:  "e5034cca46b4ff523130888f6d8bf0d75937e0f1b490a0cf0c0c175f32d8be2d"
    sha256 cellar: :any,                 arm64_sonoma:   "f9beee8dec503a6ecc7479eaec0f9f567d03d38076e4b0237e75969155df0006"
    sha256 cellar: :any,                 arm64_ventura:  "bd69993016d92420d1f32df152e891cadf75c3693e2d4d6573e4f651ca6dab10"
    sha256 cellar: :any,                 arm64_monterey: "62fcb302aec2c914524a9d00e43ccc8846f259b4a018fde0d8ef95fc32941058"
    sha256 cellar: :any,                 arm64_big_sur:  "e824b4f937e2c9a730247a738046126f1c8e8b51dac6e51cccee49bdf9f5e4e4"
    sha256 cellar: :any,                 sonoma:         "83ed6adf20c3aab46389e50e31f5dbe2927b0407f39023309f0e5097eeb93281"
    sha256 cellar: :any,                 ventura:        "b8a120ca8adc82fa6710b97eafb56d98d33dca6d74a08945dbabe23f16d52b5f"
    sha256 cellar: :any,                 monterey:       "93a1a47cac82b6c89aca67977bd4cad5ee431645f21a95a5cf887bae551e93ee"
    sha256 cellar: :any,                 big_sur:        "a64715d90ff7d190ce1e5dd29620c267363349bb46f5fc6749faaee4c950b628"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "65707936ba8f81c9f0a9fc9666f9d1783dd658353e30fe98c263a30705757fd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0296a0ca6fde5ca5ba12b45505db769743916188a47d0b876049488f31185833"
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
      #include "X11/extensions/dmxext.h"

      int main(int argc, char* argv[]) {
        DMXScreenAttributes attributes;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
