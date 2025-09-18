class Libxext < Formula
  desc "X.Org: Library for common extensions to the X11 protocol"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXext-1.3.6.tar.gz"
  sha256 "1a0ac5cd792a55d5d465ced8dbf403ed016c8e6d14380c0ea3646c4415496e3d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "f99c389fa9f1d321eb08c9a5a53941f75e41635b1b90262c9641c8c8e48894e7"
    sha256 cellar: :any,                 arm64_sequoia:  "a0434e871b6dfa64f18757e5d6df179308bcf1b53e5fa233c7d54222be8d513b"
    sha256 cellar: :any,                 arm64_sonoma:   "50a9b29c594f9b93690466d66b52f2ac36461d956016b135a85d3dfbc883e336"
    sha256 cellar: :any,                 arm64_ventura:  "fb6852f038dacbef11883d2fb8277e517d1eb237f563f62c96996f764ef40032"
    sha256 cellar: :any,                 arm64_monterey: "d580398c8be17c909f43f110b4d8a459850f066c4ef97d7a6184c5c66242893c"
    sha256 cellar: :any,                 sonoma:         "86fd68fab7f6cdcca7212812b697efc8d2c1349ceada7c74a1eeabf0f9ec8523"
    sha256 cellar: :any,                 ventura:        "5adc7a81fe4a19ce37d33850009bd3154f6723a501c932c572d43389d2399657"
    sha256 cellar: :any,                 monterey:       "eb71965f92cd97a43eaf0e9a8a49fab31ca397be6ffcbb30f5a8edc2f8853e3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0e502f2a45fc8fa5ebce3ad027926b4060ed350f7d1f5c1c6561a5fe4d97fd8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c62be32e864f64fc9ed3392a2f6eae085350c5b929b52306ac5e26c07b38bd3f"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"
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
      #include "X11/extensions/shape.h"

      int main(int argc, char* argv[]) {
        XShapeEvent event;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
