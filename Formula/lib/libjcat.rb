class Libjcat < Formula
  include Language::Python::Shebang

  desc "Library for reading Jcat files"
  homepage "https://github.com/hughsie/libjcat"
  url "https://github.com/hughsie/libjcat/releases/download/0.2.1/libjcat-0.2.1.tar.xz"
  sha256 "a6232aeca3c3fab6dbb3bed06ec3832088b49a4b278a7119558d72be60ce921f"
  license "LGPL-2.1-or-later"
  head "https://github.com/hughsie/libjcat.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "4733498c501d59b3d93741887a4e92636623da610df0ff02c8f079d0438122ce"
    sha256 cellar: :any, arm64_ventura:  "3dd9795bd86dc7ef60589a83a3d0d04202baf1db231c79d25fe9670f8a583a75"
    sha256 cellar: :any, arm64_monterey: "0ac0e2f9bb63e03f0c7d58cd57cfdb981a6cb59c65406bee4621a72a06dc03bc"
    sha256 cellar: :any, sonoma:         "4ec0a50d5444e68a3323a1af854018bd3bbdd1a4ba0c605eb23b410344dfc7be"
    sha256 cellar: :any, ventura:        "23f5aaca4cd024e16ccff3af9206409fd1b710c7eaeef4660478f50c117926ab"
    sha256 cellar: :any, monterey:       "a67038985fc59bd9c240b243f38a4896ea4ae41d5e090d67362caa59a9515f5b"
    sha256               x86_64_linux:   "99e04fd49c127b969406b628da90fbef3b179ff1044cbdd595c931f8cd39046a"
  end

  depends_on "gi-docgen" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "gnutls"
  depends_on "json-glib"
  depends_on "nettle"

  on_macos do
    depends_on "gettext"
  end

  def install
    rewrite_shebang detected_python_shebang, "contrib/generate-version-script.py"
    rewrite_shebang detected_python_shebang, "contrib/build-certs.py"

    system "meson", "setup", "build",
                    "-Dgpg=false",
                    "-Dman=false",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"jcat-tool", "-h"
    (testpath/"test.c").write <<~EOS
      #include <jcat.h>
      int main(int argc, char *argv[]) {
        JcatContext *ctx = jcat_context_new();
        g_assert_nonnull(ctx);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gnutls = Formula["gnutls"]
    flags = %W[
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libjcat-1
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gnutls.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -ljcat
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
