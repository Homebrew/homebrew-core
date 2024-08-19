class LibgeditGfls < Formula
  desc "Gedit Technology - File loading and saving"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-gfls"
  url "https://gitlab.gnome.org/World/gedit/libgedit-gfls/-/archive/0.1.0/libgedit-gfls-0.1.0.tar.bz2"
  sha256 "306ba5b25c73a6901069f0d535b845eb13167a7be2d15f86451ae5d9016229ca"
  license "LGPL-3.0-or-later"
  head "https://gitlab.gnome.org/World/gedit/libgedit-gfls.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b908ad5a2177843aa20eca0d840fcd1cd55953db26e94640730732949b77ac55"
    sha256 cellar: :any,                 arm64_ventura:  "9d8baa526a30f2fbbc2427015ff683e7fe37f63d193d0978bc71d4b7ed896b1f"
    sha256 cellar: :any,                 arm64_monterey: "cf0e509c6f842b9a60a84a4c147cc4a58a846d259728fd88c690744251bdb586"
    sha256 cellar: :any,                 sonoma:         "758a7186100d629e16dae6aec1eb225c4993bed19df0fa86d7dcda9eaa88428a"
    sha256 cellar: :any,                 ventura:        "9b486b004595e3a99a88762999964460354cca03ec79a224bcdb7039e144f133"
    sha256 cellar: :any,                 monterey:       "711aa6c8c9ff5742eab19c7104092560fb7230db248aca3bc400194df9275c00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e03f0d1f6337bb1ee3cb02a277f824ccf514b0ee1e23d6bc6ebca5336ec6c41"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"
  depends_on "gtk+3"

  def install
    system "meson", "setup", "build", "-Dgtk_doc=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS

    flags = shell_output("pkg-config --cflags --libs libgedit-gfls-1").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    assert_equal "Unsaved Document 1", shell_output("./test")
  end
end
