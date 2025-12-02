class Gdl < Formula
  desc "GNOME Docking Library provides docking features for GTK+ 3"
  homepage "https://gitlab.gnome.org/Archive/gdl"
  url "https://download.gnome.org/sources/gdl/3.40/gdl-3.40.0.tar.xz"
  sha256 "3641d4fd669d1e1818aeff3cf9ffb7887fc5c367850b78c28c775eba4ab6a555"
  license "LGPL-2.0-or-later"
  revision 2

  bottle do
    sha256                               arm64_tahoe:   "d3c6f207816d35acd3038740b15ec3147330ebe7d50090878d003def62673900"
    sha256                               arm64_sequoia: "926e80bc2182e0bdb36a4ca054d212955ad221c792cf7b17a15f75315a802046"
    sha256                               arm64_sonoma:  "cfe7f704c7686a258efdad7a4b4406f47dc6e807f55b658fb16dd84ee227c920"
    sha256                               sonoma:        "e3c86df3e2c6aff4656165ddba3a9ee68d501a42779d114b390a6cc98310873b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "368bec5f86eb60574abaa8d9dfbe5ceb6fa4049689baf884ce2402fa81d8667c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a1f91ac57eab7c7e0c1a185480776b795e6ad722631064c280d5ced4ac83bdf"
  end

  deprecate! date: "2025-01-15", because: :repo_archived

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libxml2"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  # Fix build with libxml2 2.12. Remove if upstream PR is merged and in release.
  # PR ref: https://gitlab.gnome.org/GNOME/gdl/-/merge_requests/4
  patch do
    url "https://gitlab.gnome.org/GNOME/gdl/-/commit/414f83eb4ad9e5576ee3d089594bf1301ff24091.diff"
    sha256 "715c804e6d03304bc077b99f667bbeb062c873b3bbd737182fb2cd47a295de95"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--enable-introspection=yes",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gdl/gdl.h>

      int main(int argc, char *argv[]) {
        GType type = gdl_dock_object_get_type();
        return 0;
      }
    C

    pkgconf_flags = shell_output("pkgconf --cflags --libs gdl-3.0").chomp.split
    system ENV.cc, "test.c", *pkgconf_flags, "-o", "test"
    system "./test"
  end
end
