class Libgnt < Formula
  desc "NCurses toolkit for creating text-mode graphical user interfaces"
  homepage "https://pidgin.im/"
  url "https://downloads.sourceforge.net/project/pidgin/libgnt/2.14.4/libgnt-2.14.4-dev.tar.xz"
  sha256 "195933a9a731d3575791b881ba5cc0ad2a715e1e9c4c23ccaaa2a17e164c96ec"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://sourceforge.net/projects/pidgin/rss?path=/libgnt"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8e41afafab8780d6c9415e0be6819934f2256539126ac13ca992f20a735a4dec"
    sha256 cellar: :any, arm64_sequoia: "54589732aa242fcd90ecc861024846b94b55280206e11300614a5b537fad3809"
    sha256 cellar: :any, arm64_sonoma:  "695500c7f125f6c406172b912c445ee7d94af2520af5ae2553a65d1ab8996e4e"
    sha256 cellar: :any, sonoma:        "2bf80b7019063730cf2969de24002cee9fd5d5198607273b38b472bb92747701"
    sha256               arm64_linux:   "56791137e22a683d5eda5e39807f75c4a7350009c9d218969b5add59f54f7802"
    sha256               x86_64_linux:  "7b441c9f9f4ef6546098899d79a1a28705715d232e16e43cf1050ba96df1b00b"
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
