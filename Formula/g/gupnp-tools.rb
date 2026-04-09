class GupnpTools < Formula
  desc "Free replacements of Intel's UPnP tools"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-tools/0.12/gupnp-tools-0.12.2.tar.xz"
  sha256 "4c92f2d1a3d454ec1f5fb05ef08ca34df9c743af64c8b5965c35884d46cb005c"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]
  revision 1

  bottle do
    sha256 arm64_tahoe:   "2085bbc212516df9466cfb8c53c5bd9faf9864c8dc021ed238d6ea6b1510283c"
    sha256 arm64_sequoia: "37dd3ac2195ffdf423e3b2e21ba907bfec6c42ad419363108ca2eb1dfde4a131"
    sha256 arm64_sonoma:  "fcfb7d8815e459dedff64b0359b94cd2e1e805ec4eddbda785fd88aa4c6408c5"
    sha256 sonoma:        "17c6d68b82e895036376b40d0300f96edd9bae8134e8f6bd5b1350d77b0e1861"
    sha256 arm64_linux:   "9abd9fc3ecf06cebe86951add9411a5d3c6df8bf82718774ee8ab194d8956954"
    sha256 x86_64_linux:  "0561372946dc1e5ca75fb568d5d6eff2157694641bd42380a8c1ae0d51aa1e57"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gssdp"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
  depends_on "gupnp"
  depends_on "gupnp-av"
  depends_on "libsoup"
  depends_on "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"gupnp-universal-cp", "-h"
    system bin/"gupnp-av-cp", "-h"
  end
end
