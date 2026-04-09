class LibgeditGfls < Formula
  desc "Gedit Technology - File loading and saving"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-gfls"
  url "https://gitlab.gnome.org/World/gedit/libgedit-gfls/-/archive/0.4.0/libgedit-gfls-0.4.0.tar.bz2"
  sha256 "ce6431fa532ae8d5c43f2b84e32913744d0eb8043bd753cf9e23e225f6147d75"
  license "LGPL-3.0-or-later"
  head "https://gitlab.gnome.org/World/gedit/libgedit-gfls.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "91820ae5f87904f923ef6723e3929dc62d63785ebf15710600f4ce47cb705501"
    sha256 cellar: :any, arm64_sequoia: "34cab0af8812f4ac20e28cb89b2fb5d63e7d126a7de1f2bec249bcca94608e84"
    sha256 cellar: :any, arm64_sonoma:  "8918d916c908c7da785fd94d0b3eff1b0cd78dcebd1179c32fbdfffd35050a9f"
    sha256 cellar: :any, sonoma:        "0abd9a21bedeffb94a7f8ca4d14915a9c0adf80ad304ea44790bd081be8d55d7"
    sha256               arm64_linux:   "35e65f702ee0de556170df628119c689e70613278ffebdbe272b895af18cf986"
    sha256               x86_64_linux:  "a50e4438a2f1d34617ee014754e09c7248ebf1efc848d0c74b3aec2e609da60a"
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
