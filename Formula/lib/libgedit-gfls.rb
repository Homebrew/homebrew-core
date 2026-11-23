class LibgeditGfls < Formula
  desc "Gedit Technology - File loading and saving"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-gfls"
  url "https://gitlab.gnome.org/World/gedit/libgedit-gfls/-/archive/0.5.1/libgedit-gfls-0.5.1.tar.bz2"
  sha256 "e493de416315345d554f6b3f89b885556edf28b1110fc0656a152332a299acb1"
  license "LGPL-3.0-or-later"
  compatibility_version 1
  head "https://gitlab.gnome.org/World/gedit/libgedit-gfls.git", branch: "main"

  bottle do
    manifest_sha256 "4d3a2dcbc814b1cea4595971363cf20748a01a528df556bb3fb1ba465e4121f2"
    sha256 cellar: :any, arm64_golden_gate: "1f62a8e5f034323de4753bd4d8733210ff366627daf4f35ea7626c0235562341"
    sha256 cellar: :any, arm64_tahoe:       "f4b649cfa9170e976cf5d26c4600f451ed5a8d89a71fe5734faba242f88971ea"
    sha256 cellar: :any, arm64_sequoia:     "11c84911ddfe33c23ec3ffefab87f17bc67639c049d1ce80b62d417c1e564902"
    sha256 cellar: :any, arm64_linux:       "509475469ba3c0bfd132941244bcdfa68a760a16246b3f10eef7fdc3ae744140"
    sha256 cellar: :any, x86_64_linux:      "9dffdf88258aa6dc9b9b2e3369883de77d947becb9a9790ccf956af34cabc4fe"
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
