class LibgeditGfls < Formula
  desc "Gedit Technology - File loading and saving"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-gfls"
  url "https://gitlab.gnome.org/World/gedit/libgedit-gfls/-/archive/0.4.2/libgedit-gfls-0.4.2.tar.bz2"
  sha256 "9c6c6469a70d829b4476debe4b8b135daaa60164a6657db1fa803f28625aee2b"
  license "LGPL-3.0-or-later"
  head "https://gitlab.gnome.org/World/gedit/libgedit-gfls.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "df6de1a8aa8c4fcf8d023439c36105ac965e9f0ced53632765aecd2275e058e5"
    sha256 cellar: :any, arm64_sequoia: "cb1f4f2dc7c48d562f6b234b3bde9de30cbc5d53fbd0d108c9befa2a6bb084b1"
    sha256 cellar: :any, arm64_sonoma:  "da8a5c139fbcb4e24d1f7212cecbd882e25aa0f41a803f3f58bc5f5a14bb9c50"
    sha256 cellar: :any, sonoma:        "f4add3b16420cbc883a9996f849b35bcea24467769e883106b9a70e7bb0a37e3"
    sha256               arm64_linux:   "ae46b257a6ac4c4edd18045d792ea884f6ef09344f1a7685043c1a79f5dc2dbc"
    sha256               x86_64_linux:  "261ec133e0f94738629e10fa344363e90cd8eaa72c19ce39ea4c31a2a3c8c5e8"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "glib"
  depends_on "gtk+3"

  def install
    system "meson", "setup", "build", "-Dgtk_doc=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <gfls/gfls.h>

      int main(int argc, char *argv[]) {
        gfls_init();
        GflsUnsavedDocumentTitles *titles = gfls_unsaved_document_titles_new();
        gchar *title = gfls_unsaved_document_titles_get_title(titles, 1);
        printf("%s", title);
        g_free(title);
        g_object_unref(titles);
        gfls_finalize();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libgedit-gfls-1").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    assert_equal "Unsaved Document 1", shell_output("./test")
  end
end
