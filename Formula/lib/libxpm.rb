class Libxpm < Formula
  desc "X.Org: X Pixmap (XPM) image file format library"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libXpm-3.5.20.tar.gz"
  sha256 "736704d843459abbf769560ff8e443a5de4e6023082e7086c9d195253ada17ff"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bd2bede2f5d67c7738b16674aee2adda460281e5cd06d4d6ce3208cd3e56c862"
    sha256 cellar: :any, arm64_tahoe:       "5c18c69c73b995e1f64533b6967132c366478e4655517f5a2008a3e9ebb0fe2b"
    sha256 cellar: :any, arm64_sequoia:     "dbd4617a2e688e7ad53b4adc4ad7937180c3cb997a2aa67e15b03043e39af515"
    sha256 cellar: :any, arm64_linux:       "145a09ecd50931329b3a247313a6ed67500e4889cc54cf5621b1cb1a666d5ea7"
    sha256 cellar: :any, x86_64_linux:      "219a5e5e1e5b023a4b44ba0b441f99714beb7579527908e2b02654d0b9cac6c8"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "libx11"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-open-zfile
      --disable-silent-rules
      --disable-stat-zfile
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/Xlib.h"
      #include "X11/xpm.h"

      int main(int argc, char* argv[]) {
        XpmColor color;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
