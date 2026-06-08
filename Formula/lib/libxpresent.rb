class Libxpresent < Formula
  desc "Xlib-based library for the X Present Extension"
  homepage "https://gitlab.freedesktop.org/xorg/lib/libxpresent"
  url "https://www.x.org/archive/individual/lib/libXpresent-1.0.2.tar.xz"
  sha256 "4e5b21b4812206a4b223013606ae31170502c1043038777a1ef8f70c09d37602"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e80e27e85c020a9a1391bb318b8a3e4b03fcce7be8dd604a2eb85c6ee1e56d01"
    sha256 cellar: :any,                 arm64_sequoia: "44593e71ec9078d0ac8b918fec8991bd2415c7daebb067e7e4b6e881e0f8fd7a"
    sha256 cellar: :any,                 arm64_sonoma:  "87448d6b9c94a14eb8e087602dd2696dcd9b29dde23ba359f14e491502ce6d69"
    sha256 cellar: :any,                 arm64_ventura: "3942db3a8d6bd9d70c26030daba6b2751c2ab33608f278129bca020f2acdce2d"
    sha256 cellar: :any,                 sonoma:        "0e2b2206c01d044ac97976f685773bc44aa68322afe982f71564d48172c0c052"
    sha256 cellar: :any,                 ventura:       "22bc417dfff907b31eb49975f899777c277d2dd3fe944f24bcde1c1f8dec5a0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "539cbabee52ea3998d89e147b884d3b4c6743b3c14f18e15a145958e3d8eddef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9410dc0e6850979043f5454de952ba1c1360cd4e7f1a011b8faf4b3475553ad9"
  end

  head do
    url "https://gitlab.freedesktop.org/xorg/lib/libxpresent.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "util-macros" => :build
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxfixes"
  depends_on "libxrandr"

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <X11/extensions/Xpresent.h>

      int main() {
        XPresentNotify notify;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
