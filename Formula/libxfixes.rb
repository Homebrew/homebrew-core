class Libxfixes < Formula
  desc "X.Org: Header files for the XFIXES extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXfixes-6.0.0.tar.bz2"
  sha256 "a7c1a24da53e0b46cac5aea79094b4b2257321c621b258729bc3139149245b4c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c7f7012b751ab6c83a41cec7c95f6628a2c1d3e2a9f2f1271ee7a8a5844c1a5d"
    sha256 cellar: :any,                 arm64_big_sur:  "9668a973a8a220609add6d2af60547745b81cb198936930fcd05bfd6b9aca47c"
    sha256 cellar: :any,                 monterey:       "7325a129c439a5239c04b469d456ca5ec3ca6d93bc444aa25be30973b61f5cfd"
    sha256 cellar: :any,                 big_sur:        "a0317884b16dfd0e391d9ab48b4a9785fa2c4fdf3fd5dca857be98b1ae6fded2"
    sha256 cellar: :any,                 catalina:       "916d95deb297ee98b57a87586a90a5a880792efab259c511230844a6ab94d06e"
    sha256 cellar: :any,                 mojave:         "5c560e7ae60a53ea414c34a7d5159da0e4fc04a9159baa4ce9d67d942d05b9a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b10945be16e84b8e7cd08c600d64408e1332574f1fa8e33a44aadb3bf5e06d68"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
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
      #include "X11/extensions/Xfixes.h"

      int main(int argc, char* argv[]) {
        XFixesSelectionNotifyEvent event;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
