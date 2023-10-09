class Gssdp < Formula
  desc "GUPnP library for resource discovery and announcement over SSDP"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gssdp/1.6/gssdp-1.6.2.tar.xz"
  sha256 "410b376deeced9836b57f488f80052fe4a14f89e075b1ceccf28e51f490f9fb9"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "f66a3c00786eeaa115d631b7d965a173faf5282713c0582433b5f5c6a8c6e825"
    sha256 cellar: :any, arm64_ventura:  "6701a2078922a13caa8c7f09474c41eeb2e459a53749436f930bba454eafb0ea"
    sha256 cellar: :any, arm64_monterey: "6c8e3452a6be3e1979f22a3fed7c735cfd0d6079d516c9488f9c39a692620f25"
    sha256 cellar: :any, arm64_big_sur:  "bd4de4c06d98ee9aa8510749553f7f5691b32a41dd9f741a9b72455b828027cc"
    sha256 cellar: :any, sonoma:         "c31078fe8fa764d0a302fdc13d6cdeab24c4bc36d0b5588ca4f06980deb9e8e6"
    sha256 cellar: :any, ventura:        "d848a54ccae3f584f55a642882b80a608ace5676119801ae6aa5c4da60ab9505"
    sha256 cellar: :any, monterey:       "1f355bf2303dcfe429cc74fc544f61e782eef5a01ebb3900a1b35d28c43ca95b"
    sha256 cellar: :any, big_sur:        "fe653acf7db752b092cb3d778211b3937b1feffb7dd03f925b58e1943b072582"
    sha256               x86_64_linux:   "8e2b9ea4bdf09f66ccefc2fb3e7a2e2dcf380881a4ec35fd0e67ba1c93223c61"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libsoup"

  def install
    ENV.prepend_path "XDG_DATA_DIRS", HOMEBREW_PREFIX/"share"

    system "meson", *std_meson_args, "build", "-Dsniffer=false"
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libgssdp/gssdp.h>

      int main(int argc, char *argv[]) {
        GType type = gssdp_client_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gssdp-#{version.major_minor}
      -D_REENTRANT
      -L#{lib}
      -lgssdp-#{version.major_minor}
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
