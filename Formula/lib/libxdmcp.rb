class Libxdmcp < Formula
  desc "X.Org: X Display Manager Control Protocol library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXdmcp-1.1.4.tar.xz"
  sha256 "2dce5cc317f8f0b484ec347d87d81d552cdbebb178bd13c5d8193b6b7cd6ad00"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6c24a3eee6cb6ca578ecebe8d7c5c3286e2d59f0d3b3ee7398b25753ad00a833"
    sha256 cellar: :any,                 arm64_ventura:  "2fb2d55b8f9722e68eeb76bcd77d3e9d5bbe52c96db2c05ceb70152f0ff4883d"
    sha256 cellar: :any,                 arm64_monterey: "7ead4738215915004a6f3333584cbcb7ae1accb1b9b0a4742708e276c64ff984"
    sha256 cellar: :any,                 arm64_big_sur:  "3846fc5ceb4900e7bedb3ab6bcb8569f9beef52a60a6c2dfe3d16897ee7058f4"
    sha256 cellar: :any,                 sonoma:         "81c4ce16b95b26bf91fcb1eac4d107d8166a5435b573371214bd20c8bad48d44"
    sha256 cellar: :any,                 ventura:        "df9e4852a82d03c0388ed638999cb5dfe625b8e5b0b26e6ee2363529c0cc31bd"
    sha256 cellar: :any,                 monterey:       "16a26bf976f76e256466dc045e9691ef3cae5427fb7205274f17a1b37372c67b"
    sha256 cellar: :any,                 big_sur:        "2ed240f04f505a9472bc3f1988ba9be5edb9107795ab72f02a2ed7608d7de918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8b1aa6dd84bc12a8c53ab0069d92cc918c7e75e987d0ddeacabd44fec5e0f2d"
  end

  depends_on "pkg-config" => :build
  depends_on "xorgproto"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-docs=no
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/Xdmcp.h"

      int main(int argc, char* argv[]) {
        xdmOpCode code;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
