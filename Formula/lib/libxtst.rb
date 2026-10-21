class Libxtst < Formula
  desc "X.Org: Client API for the XTEST & RECORD extensions"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libXtst-1.2.6.tar.gz"
  sha256 "f30f2d4f8370077de9f35220a539bf34c042ca02a55669a4d8f345c661ce7839"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "99e1bb69e67e3f12060f65a963b42f7a414e42304af01c19cac344fe7fe8bba8"
    sha256 cellar: :any, arm64_tahoe:       "4cccd2f54e0b00cf2e0be69f1f978ab36f033851b091a22a7413174bbdc6ad7e"
    sha256 cellar: :any, arm64_sequoia:     "1c3749e2a12829869eb8b6a85feb805cb0abcbb7ad928cdf7c706de4d9a5a75e"
    sha256 cellar: :any, arm64_linux:       "cfd02c4c61b6556a34c4e13552c6d3086b6d625d4c412462d1fbcd8367a1ace1"
    sha256 cellar: :any, x86_64_linux:      "6ac18f8733259cc308962131433f580e028155cd2e3cc57dd6b9c7500dac0e16"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build

  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxi"
  depends_on "xorgproto"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      --enable-specs=no
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/Xlib.h"
      #include "X11/extensions/record.h"

      int main(int argc, char* argv[]) {
        XRecordRange8 *range;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
