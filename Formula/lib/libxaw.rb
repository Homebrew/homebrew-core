class Libxaw < Formula
  desc "X.Org: X Athena Widget Set"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXaw-1.0.16.tar.xz"
  sha256 "731d572b54c708f81e197a6afa8016918e2e06dfd3025e066ca642a5b8c39c8f"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "9bb4e4ecf08fb26def1ea47044c0212419322da6e75be9c4941c3269a7980136"
    sha256 arm64_ventura:  "a2bd1b54c0ee384adca4e26884e0227f0fa14a1ad9f97cee796eae62c958daa6"
    sha256 arm64_monterey: "c0fcd5adff5cd8cd3baed32a39cfc7fe562277d071fdc9af355af24148969e65"
    sha256 sonoma:         "43723594cd2a5eecdfb3cbbdd7fe0dbf450c69f3d946a6f153215248de3551ac"
    sha256 ventura:        "3fffe8ae45a0f42386a0ade97bd729ba73538e17cce3de42c9b3f477ec505603"
    sha256 monterey:       "f530f6c416ef2fc96eeade9d6f4d5334baa6a6f1c5da1a70ef4dc8a3a6f8099d"
    sha256 x86_64_linux:   "18f64e719e125084fe24176f8e137851cd5ee87ebf338e7e87988d7e212a2da8"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxmu"
  depends_on "libxpm"
  depends_on "libxt"

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
    (testpath/"test.c").write <<~EOS
      #include "X11/Xaw/Text.h"

      int main(int argc, char* argv[]) {
        XawTextScrollMode mode;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
