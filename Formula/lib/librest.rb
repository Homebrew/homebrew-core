class Librest < Formula
  desc "Library to access RESTful web services"
  homepage "https://gitlab.gnome.org/GNOME/librest"
  url "https://download.gnome.org/sources/librest/0.10/librest-0.10.2.tar.xz"
  sha256 "7b6cb912bb3a22cfa7dcf005925dcb62883024db0c09099486e7d6851185c9b8"
  license all_of: ["LGPL-2.1-or-later", "LGPL-3.0-or-later"]

  # librest doesn't seem to follow the typical GNOME version scheme, so we
  # provide a regex to disable the `Gnome` strategy's version filtering.
  livecheck do
    url :stable
    regex(/librest[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4953ad6e88b6646bcf562d66193b617cbd2bba6c9dfecb37eed108f971be575b"
    sha256 cellar: :any, arm64_sequoia: "22bd743bb1c8dd2453fd90278636395f2cafb6fe2adb734e67f1cfc2e7ac4333"
    sha256 cellar: :any, arm64_sonoma:  "0a87dcb8ffcc161c718f36342ba14c14ed6f82bd4b4a54be4b0d54f0df3f1966"
    sha256 cellar: :any, sonoma:        "f3019e4787530901ecbddda6775b47cedd8c44f1b7d7441e458675bc8ae31500"
    sha256               arm64_linux:   "a2ed194719ac2d8318a309c63da0506d345c83691d1481ca4545579b874b40ef"
    sha256               x86_64_linux:  "44ba6aff805854a906f060100e335f0d608618ceda53249ecd9c6b0d8b0df58d"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "glib"
  depends_on "json-glib"
  depends_on "libsoup"

  uses_from_macos "libxml2"

  def install
    system "meson", "setup", "build", "-Dexamples=false", "-Dgtk_doc=false", "-Dtests=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <rest/rest-proxy.h>

      int main(int argc, char *argv[]) {
        RestProxy *proxy = rest_proxy_new("http://localhost", FALSE);

        g_object_unref(proxy);

        return EXIT_SUCCESS;
      }
    C

    flags = shell_output("pkgconf --cflags --libs rest-1.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
