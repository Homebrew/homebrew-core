class LibgeditGfls < Formula
  desc "Gedit Technology - File loading and saving"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-gfls"
  url "https://gitlab.gnome.org/World/gedit/libgedit-gfls/-/archive/0.2.1/libgedit-gfls-0.2.1.tar.bz2"
  sha256 "a286902dce8c02edc134f5eb0e674ad7b3378bebad3f041fc5187c5baf6e485e"
  license "LGPL-3.0-or-later"
  head "https://gitlab.gnome.org/World/gedit/libgedit-gfls.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8662b92890c2c3dfc32eb4b582a8464f3d44586a9ac49c49a44430ec4eadee8e"
    sha256 cellar: :any,                 arm64_sonoma:  "b04dbb63a1b14450aa40ef218b50510754b9bf558639f0e8985e4d65593cf401"
    sha256 cellar: :any,                 arm64_ventura: "a613ffbefe64500340ab6223620f7d9e718a6a5afa9bbdf6b7e713b1d95a999f"
    sha256 cellar: :any,                 sonoma:        "ebae2677d8f6ad7abfa89e4214b5483a5875c106171018dd0a7278719631d405"
    sha256 cellar: :any,                 ventura:       "0247b766950405b91390c9aa8ef80511e7a6d17fed29e2db948c222e8fe1ea46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "007db5e00747953c2dc33218505fbd76943c4f66fb14d2cd6d56aa953391c1e7"
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
