class Libxrender < Formula
  desc "X.Org: Library for the Render Extension to the X11 protocol"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXrender-0.9.11.tar.gz"
  sha256 "6aec3ca02e4273a8cbabf811ff22106f641438eb194a12c0ae93c7e08474b667"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ae75035fb02f10c04b256a0dcb5b51498e5e99f98baebdcbc9819c35fddbb704"
    sha256 cellar: :any,                 arm64_sonoma:   "387261107110957df83504ec68c9328d84b3ce5a1f2a8e01f7d8f9112d8372ad"
    sha256 cellar: :any,                 arm64_ventura:  "510d0cd0f72480d716b38cd935e3a334ed1be972210ffac7309d0dd80469c8bb"
    sha256 cellar: :any,                 arm64_monterey: "660b41237f01b7561da61e4abd212f4575e6c97f4c76cc70c550868edbe227e5"
    sha256 cellar: :any,                 arm64_big_sur:  "2ed6a16e43342c1a068a59c7f250111d88ef0f7d7e0ae7c935cb979f09542a57"
    sha256 cellar: :any,                 sonoma:         "f61874ac3d98dfed35aa0a8790a71fa3a802d3d310d2e57e35570219a5864800"
    sha256 cellar: :any,                 ventura:        "5eb0bb57e683a00176a5702bdf021641fe9290e84e0414d2979823ad0aad1d3a"
    sha256 cellar: :any,                 monterey:       "ab54f6ca9a3dc9c86a16813ebc86456a012dace089f51b2c8d16aea72cd78ec5"
    sha256 cellar: :any,                 big_sur:        "be6b3af9fd07f7a95bf2a70e1673383dca5ba972a6984ba359ea0c36be2dee44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e83a61cd4894dea2942520f9147fdaa1e92b71089f288f6a1ae2fb1236b79f5"
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
      #include "X11/Xlib.h"
      #include "X11/extensions/Xrender.h"

      int main(int argc, char* argv[]) {
        XRenderColor color;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
