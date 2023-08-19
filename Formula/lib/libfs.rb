class Libfs < Formula
  desc "X.Org: X Font Service client library"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libFS-1.0.9.tar.gz"
  sha256 "8bc2762f63178905228a28670539badcfa2c8793f7b6ce3f597b7741b932054a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "83d66a7401ced50e34fc67a41d9b6588ff4814db6a7d3d0755f9fafc8f6714be"
    sha256 cellar: :any,                 arm64_monterey: "f0bb367c87a5ba7277d18ba85b182f2798fb97c452efb2eb009babfdd9e643ed"
    sha256 cellar: :any,                 arm64_big_sur:  "cb3721124d0d238ab17cb95b3cfcb0e2f33fcfb108b4d4c1dd7e06bd86c0e8f8"
    sha256 cellar: :any,                 ventura:        "974bf7da110902108bc424e2859311b39de0216dda958e0f35655c8cf600967d"
    sha256 cellar: :any,                 monterey:       "256188f15600637e5840d3d2a555754909136abcd4526f4bdb6381c8ec69a2e9"
    sha256 cellar: :any,                 big_sur:        "c763b89eb5b60b5ccd7868d99dc96c02e1d988b86fe0cfdcea1353e60f39a73e"
    sha256 cellar: :any,                 catalina:       "c164c40a1951e3f30488202d1c872e7c6ed8cf020ff7af0b4d338fceecc00617"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4da549deeaec2724ca7d5ef88df95998aab656a61710ca48eb71a27ddc55a9b8"
  end

  depends_on "pkg-config" => :build
  depends_on "xtrans" => :build
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
      #include "X11/fonts/FSlib.h"

      int main(int argc, char* argv[]) {
        FSExtData data;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
