class Libxvmc < Formula
  desc "X.Org: X-Video Motion Compensation API"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXvMC-1.0.15.tar.xz"
  sha256 "4f518afde3d7fd435346af7b368d2f73517f3d5f82647c962caf3f7bb8ff7078"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "267771872f4f7a19028eb02f3feb518481be7959de54eae92e41bd755537c039"
    sha256 cellar: :any,                 arm64_sequoia: "7a30942d073d11202a0f74fd445689aea720b70dc87edac83f401f38d48e6048"
    sha256 cellar: :any,                 arm64_sonoma:  "62e52f8a2d29e4bf06aad9f310204eae310c2ae3c8aed442f9ba37b2e627ca65"
    sha256 cellar: :any,                 sonoma:        "f0b4c4ae0c87bb7d3aa4b1056d494077677b405a08fc4084762f8e21fc76a929"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03ffa01a63ab72806a91a7008895493bcde262573772680d87797b54a2a28907"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49257f4df10257414f75749016d97d2f2fa7e9a7c124265c041458c9c567b10a"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxv"

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
      #include "X11/extensions/XvMClib.h"

      int main(int argc, char* argv[]) {
        XvPortID *port_id;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
