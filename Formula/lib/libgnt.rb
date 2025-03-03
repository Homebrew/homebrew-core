class Libgnt < Formula
  desc "NCurses toolkit for creating text-mode graphical user interfaces"
  homepage "https://keep.imfreedom.org/libgnt/libgnt"
  url "https://keep.imfreedom.org/libgnt/libgnt/archive/v2.14.4.tar.gz"
  sha256 "40840dd69832fdae930461e95d8505dabc8854b98a02c258c8833e0519eabe69"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://keep.imfreedom.org/libgnt/libgnt/tags"
    regex(%r{href=["']/libgnt/libgnt/rev/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "06e99df7a279d7a4f75274f96a0db2f6afe0c6b234bbc92d967f289d001cc4c5"
    sha256 cellar: :any, arm64_sonoma:   "92cb079a6648bbd97c733c00ab6d0ca2bbaa10fa07dd7edafe0e467d59cd928d"
    sha256 cellar: :any, arm64_ventura:  "cef0929d73436e28d17b5373a7088b7cbebddb53cd2aa5ae332e8b3c7264b2d5"
    sha256 cellar: :any, arm64_monterey: "0345644c556d7cca3a1974f1d716ca906b3a9819122b8832af2f5fe436febe44"
    sha256 cellar: :any, sonoma:         "b935c28f5db2f8b807c8550f02eb766793bf324a7b6beaa5f7e83b4dd4671e37"
    sha256 cellar: :any, ventura:        "9e74dedfc9bc7dd2d44936fa08782aa46bf4e8b9fcf448ba6dfbab1390b229d5"
    sha256 cellar: :any, monterey:       "b8ee230409a87a54eb1739b0df20eb82c121d0a6d53674b2d8503476fd315b27"
    sha256               x86_64_linux:   "a1aeee55bd6025c795083d7889415358ab4241b74bc37cd7392833e971eae98d"
  end

  depends_on "gtk-doc" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "ncurses"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    # upstream bug report on this workaround, https://issues.imfreedom.org/issue/LIBGNT-15
    inreplace "meson.build", "ncurses_sys_prefix = '/usr'",
                             "ncurses_sys_prefix = '#{Formula["ncurses"].opt_prefix}'"

    system "meson", "setup", "build", "-Dpython2=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gnt/gnt.h>

      int main() {
          gnt_init();
          gnt_quit();

          return 0;
      }
    C

    flags = [
      "-I#{Formula["glib"].opt_include}/glib-2.0",
      "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
      "-I#{include}",
      "-L#{lib}",
      "-L#{Formula["glib"].opt_lib}",
      "-lgnt",
      "-lglib-2.0",
    ]
    system ENV.cc, "test.c", *flags, "-o", "test"
    system "./test"
  end
end
