class LibgeditGfls < Formula
  desc "Gedit Technology - File loading and saving"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-gfls"
  url "https://gitlab.gnome.org/World/gedit/libgedit-gfls/-/archive/0.5.0/libgedit-gfls-0.5.0.tar.bz2"
  sha256 "d9bf8277c790c3c3164c4bc6d0623d16a336921b2c29de90974904e6f94a3ad8"
  license "LGPL-3.0-or-later"
  compatibility_version 1
  head "https://gitlab.gnome.org/World/gedit/libgedit-gfls.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "539dbe3fee2b42d70d792922a709aca0a9439bdd09cfc1fc279928d189e07c73"
    sha256 cellar: :any, arm64_tahoe:       "1395510717f99eed3b23aa122a61603653e4ad90940bcc95e1be6b336ba78139"
    sha256 cellar: :any, arm64_sequoia:     "11de47d2be155cffb0c645ff21b0a6ecaf7b6fff38f85551689d9b15e56bddae"
    sha256 cellar: :any, arm64_linux:       "9c5de947d55fda81f42ef25745f394b3fdf1383cb49efbf7e016e96fe3b96412"
    sha256 cellar: :any, x86_64_linux:      "9ebc0943e0ef0236483e631ff65fda3f0b202b13ccdef46bf45662e6aa46e8e9"
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
