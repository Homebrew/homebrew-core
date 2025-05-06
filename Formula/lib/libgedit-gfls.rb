class LibgeditGfls < Formula
  desc "Gedit Technology - File loading and saving"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-gfls"
  url "https://gitlab.gnome.org/World/gedit/libgedit-gfls/-/archive/0.3.0/libgedit-gfls-0.3.0.tar.bz2"
  sha256 "a53c847a2dc16f35a9295b2176bde4dbaa91bd1410af8546992fd65236bccf95"
  license "LGPL-3.0-or-later"
  head "https://gitlab.gnome.org/World/gedit/libgedit-gfls.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "4d224b0d0ecad55f58e7faad216c4456bc8a034b31f120714d94bed236360dc2"
    sha256 cellar: :any, arm64_sonoma:  "217681e399331b45c9a8e12a7eeb02e520dcab102e634163292907005cb83b16"
    sha256 cellar: :any, arm64_ventura: "910ff5cc9d9f6bf34bc028886291f5b865830872e538115c3610d5a62a15b570"
    sha256 cellar: :any, sonoma:        "db720dd55a7f2c887fef60c79036d93d65d439c7f8e159f339ccb3c2ef66ba32"
    sha256 cellar: :any, ventura:       "4eb809e0498a4a2844c2afa2d2255cdb5d7827b9d1925d7d561540b58bbcc248"
    sha256               arm64_linux:   "4414cd365718587e2ba528a90fa5615678b4f8e5f6e7b881be663dac820a45ae"
    sha256               x86_64_linux:  "56b8e1b605aa397988beb3cb33cc9d394a83413468c7e68d22e78daab6d174fd"
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
