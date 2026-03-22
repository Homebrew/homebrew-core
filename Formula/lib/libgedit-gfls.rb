class LibgeditGfls < Formula
  desc "Gedit Technology - File loading and saving"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-gfls"
  url "https://gitlab.gnome.org/World/gedit/libgedit-gfls/-/archive/0.3.1/libgedit-gfls-0.3.1.tar.bz2"
  sha256 "fef85c08abff129199ba59444825d602c3aad8346cba48677a58a6421daad46d"
  license "LGPL-3.0-or-later"
  head "https://gitlab.gnome.org/World/gedit/libgedit-gfls.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "094a4573c2d02e1abf7802c22e526f1088750c23fc446bb22d8c1f59a2ee2d44"
    sha256 cellar: :any, arm64_sequoia: "8db07fb4c7b54d03cbff3825099e2aac1fac8bd05e2f6c2394ee04fdb2917d94"
    sha256 cellar: :any, arm64_sonoma:  "7a5b3641096059b45f2493f03a020dc5892c71ccc608f7aaffd38f8ba40cc5fe"
    sha256 cellar: :any, sonoma:        "2a74de4486d4c26f60e821abc4fd08c1ae61597785298fdf5bd8f5a3b8c37f6c"
    sha256               arm64_linux:   "1a9b830716ce11ade5e9970175836b0244c6798bbcc0d237b3ba643ea1c183a5"
    sha256               x86_64_linux:  "6621aa963f78c982fa874bbfd0262b5ff26bcf5b06236d545520b6b121fcb64c"
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
