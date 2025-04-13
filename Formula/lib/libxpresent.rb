class Libxpresent < Formula
  desc "Xlib-based library for the X Present Extension"
  homepage "https://gitlab.freedesktop.org/xorg/lib/libxpresent"
  url "https://www.x.org/archive/individual/lib/libXpresent-1.0.1.tar.xz"
  sha256 "b964df9e5a066daa5e08d2dc82692c57ca27d00b8cc257e8e960c9f1cf26231b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "7e63498b20190e5cafd0a9adfe036c47a39bcc561518f856d01d168fb801997a"
    sha256 cellar: :any,                 arm64_sonoma:   "5154234d565eec07b6546e1bc9eba8b561dff0200e128f637eff35bda1b52a16"
    sha256 cellar: :any,                 arm64_ventura:  "fe13d712a8cf2ebba7de9d9d1cac8b606eead4439ecd0be941765bd6ca4872b0"
    sha256 cellar: :any,                 arm64_monterey: "4e3e3cd9ff60f75b914f230398805e086864e82d7c3b7b3b2be01d73275dd53d"
    sha256 cellar: :any,                 sonoma:         "eb83e0d03a31d7ea8cd48cd3d43bdeb5d0048af0d06646c446e568ec7a3013ca"
    sha256 cellar: :any,                 ventura:        "3e03a11b61ba1ffe208a8d81a0758bf7035a121d8628ee1060bda1806acc74fe"
    sha256 cellar: :any,                 monterey:       "55bad28f062443796869c41b7c9c5937786fe92cbb9b68794818d7c077d1dbc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "15d2a13ac97e3109624e052570ae65cb4262f3702bd2bfcaf929b552cccd51b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cb8e78a41a28a3614a7db1df840c1b1c30c96edf2dc6bd6dc49824709b47305"
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
