class LibgeditGfls < Formula
  desc "Gedit Technology - File loading and saving"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-gfls"
  url "https://gitlab.gnome.org/World/gedit/libgedit-gfls/-/archive/0.2.0/libgedit-gfls-0.2.0.tar.bz2"
  sha256 "4a01265feb9764718463ff723d4a9f2287ee118a95739c94415d1d09a2d7a6b5"
  license "LGPL-3.0-or-later"
  head "https://gitlab.gnome.org/World/gedit/libgedit-gfls.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6fb8a80dfa4bd1c5ba6ac06adf055ec239645b184349692d3743b93bf9ce507d"
    sha256 cellar: :any,                 arm64_sonoma:   "82ac1af81efcb7893196f48966640337663111c345e800f6f61724a5d7e76fc9"
    sha256 cellar: :any,                 arm64_ventura:  "ec53959d595fe8882ad2b174dd27b7e1b4cc95a333160f6a6a84f03b789fa753"
    sha256 cellar: :any,                 arm64_monterey: "d25070248fbef2ace283f567ff3cbaea9f79ce1f335d5b898136da852f3d67be"
    sha256 cellar: :any,                 sonoma:         "34f365abbd0cb49584469d32f21fd99e885f1b7981e7da34adc7535c44d781ed"
    sha256 cellar: :any,                 ventura:        "53cec0319c92047dee1b11b34c93a2a683ff29b74c1ec13261995b87c07353f6"
    sha256 cellar: :any,                 monterey:       "dba99132697b04b825fa5cc12aaddc490524b06d5fd2d7f5927773716ba84b11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f62b44c9e7e1d3102ab86c0e9807e06ae0366f16e4b72bd704ba64d80f6459d"
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
