class Libfontenc < Formula
  desc "X.Org: Font encoding library"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libfontenc-1.1.6.tar.gz"
  sha256 "c103543a47ce5c0200fb1867f32df5e754a7c3ef575bf1fe72187117eac22a53"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f23f0279bc054bde576d3293be23816daccdd26ee4762d5205939263ad2d49f8"
    sha256 cellar: :any,                 arm64_big_sur:  "f7686ee1ce6e835a5d77a19ed8465d616540f9d265b2cb78c6570d88c2067846"
    sha256 cellar: :any,                 monterey:       "14a5217c02e866e05ddabc921afa63221d9a819e49eef226e8763f46ad17d158"
    sha256 cellar: :any,                 big_sur:        "b79028b9bd6cef0360242c108cd1448d233581d61b3b7ff5cfd193d11859a64c"
    sha256 cellar: :any,                 catalina:       "4cd9ff461d62102e81f811d50433a653fae4074eff499a0774fb1d6dc8573284"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e23824b3f78b547a79e23d411120141db1e8bc9a803f0ef84db417d066b8c41a"
  end

  depends_on "font-util" => :build
  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build

  uses_from_macos "zlib"

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
      #include "X11/fonts/fontenc.h"

      int main(int argc, char* argv[]) {
        FontMapRec rec;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
