class Libxinerama < Formula
  desc "X.Org: API for Xinerama extension to X11 Protocol"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXinerama-1.1.5.tar.xz"
  sha256 "5094d1f0fcc1828cb1696d0d39d9e866ae32520c54d01f618f1a3c1e30c2085c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "69863001935cc52cff4322674c03ab0e0f429ca424cf619135459571a9712677"
    sha256 cellar: :any,                 arm64_monterey: "dc7b122a398f22ad751700145dc9d3b82f2fb60fc85a64daf3a71e0761c3e140"
    sha256 cellar: :any,                 arm64_big_sur:  "d7684cd44466dcd3c40308e3ca5dc0c5aa50ff4dbb18aaeb3e82a80bc80be785"
    sha256 cellar: :any,                 ventura:        "f23db58ccad8b14e8c76a410079ca8add6bd124c9aa2cb63ba93ac532e5f35ad"
    sha256 cellar: :any,                 monterey:       "88432ad0c1e14a8511e0fb345d9bcf0e9ee67e7b634b32b31b75ce2d66ac0051"
    sha256 cellar: :any,                 big_sur:        "0f99b4d8757fdfe3b0c087b1112d49dc625c1d342f6e5c6beba44063f8c1ae33"
    sha256 cellar: :any,                 catalina:       "c11a3acfe1397ac78ff73b16f33781af781bb510773f29c4cde93a80b37ffacc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8bcf697bd80954325c6994d562554f890ab0fd6e35ae671f0886a05bcacc29b"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "xorgproto"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/extensions/Xinerama.h"

      int main(int argc, char* argv[]) {
        XineramaScreenInfo info;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
