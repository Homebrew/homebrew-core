class Gom < Formula
  desc "GObject wrapper around SQLite"
  homepage "https://wiki.gnome.org/Projects/Gom"
  url "https://download.gnome.org/sources/gom/0.4/gom-0.4.tar.xz"
  sha256 "68d08006aaa3b58169ce7cf1839498f45686fba8115f09acecb89d77e1018a9d"
  revision 3

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_sonoma:   "7739014948192b14ae5c9de59e4a084fb90c1e77344e98758ff91e4380388d4d"
    sha256 cellar: :any, arm64_ventura:  "d143d27a4e26d5f294f82821fd44abb9e9c52b6b5ebdee505b53a40dc88e3c09"
    sha256 cellar: :any, arm64_monterey: "338326e04cdc74b498710c1e70ba56426766f72af7b408437cd619c9418f9c28"
    sha256 cellar: :any, sonoma:         "a9815d6dfa43929208561f932997fa22cda9494722880f1af03435652731af54"
    sha256 cellar: :any, ventura:        "1594e2a96cd9e5935dbaf0f211d32ccd92e6eeef7d2722f836269c6ac7a04ed8"
    sha256 cellar: :any, monterey:       "f32dd6c31b283feabdc6c91025ebf1f4e6a769fd2c70db73854228f871313df2"
    sha256               x86_64_linux:   "33c91d940b43a24d21cbb493be57d13f2285a74c44cced7aed47fe49f0a51957"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"

  uses_from_macos "sqlite"

  def install
    site_packages = prefix/Language::Python.site_packages("python3.12")

    system "meson", "setup", "build", "-Dpygobject-override-dir=#{site_packages}", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gom/gom.h>

      int main(int argc, char *argv[]) {
        GType type = gom_error_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gom-1.0
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lgobject-2.0
      -lgom-1.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
