class LibgeditGfls < Formula
  desc "Gedit Technology - File loading and saving"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-gfls"
  url "https://gitlab.gnome.org/World/gedit/libgedit-gfls/-/archive/0.4.1/libgedit-gfls-0.4.1.tar.bz2"
  sha256 "e252267943c6f582d6314969c9b33066635fe04ff518e7292f5fd461c60acdd4"
  license "LGPL-3.0-or-later"
  head "https://gitlab.gnome.org/World/gedit/libgedit-gfls.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7e55cbd00cf749d58345ca118fb9468fb284a9d726f7d0118d8ef4ba98383408"
    sha256 cellar: :any, arm64_sequoia: "f4df6a2aec1f4ce03578b336ba39ef1da885f53c328a9fa6a0eef67fa2533447"
    sha256 cellar: :any, arm64_sonoma:  "be003bf0922c2d9715a9c8c7bfe7dd12ef75b271a80a349276cb429cebe6aa21"
    sha256 cellar: :any, sonoma:        "181a65a9ba66e11bf2d1e3fa9e37aab8f6d155723ed050af10772e27295f7bf1"
    sha256               arm64_linux:   "9e5d8ea86667dbaf34f43d755772f21acc79446f77c46f09312ff1a6c366abec"
    sha256               x86_64_linux:  "7c5b31b7e38c74f762c942eef1bdd3fefb1e2725b6eae2531fd4336989525987"
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
