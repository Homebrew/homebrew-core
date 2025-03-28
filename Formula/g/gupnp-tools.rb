class GupnpTools < Formula
  desc "Free replacements of Intel's UPnP tools"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-tools/0.12/gupnp-tools-0.12.2.tar.xz"
  sha256 "4c92f2d1a3d454ec1f5fb05ef08ca34df9c743af64c8b5965c35884d46cb005c"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]
  revision 1

  bottle do
    sha256 arm64_sequoia: "d769ee08439b846b2a90fff8ac563aef69c0e5b9aeeb4f04c79d843b892c36b8"
    sha256 arm64_sonoma:  "065c59cdc36ec8557bdca9bc3da04847cfcd2e7e55ea4a161e6ee669601639d0"
    sha256 arm64_ventura: "323caa61cc2fcb5fb594cd8c84f6761530bfb7e48fa160ae77f491ea98d1fe5c"
    sha256 sonoma:        "58c18fa2d0b58685ddb29a4d05064b4b1b76f537a63c943d6ba9db792a40b0d5"
    sha256 ventura:       "e9282722d1cba7a1661fa377fb504f6162350fc45382417172ae4babeab4ba8b"
    sha256 x86_64_linux:  "6159c1527a0dfef2c43b726927c57fc69d64b0a51d4ff6a42809dea33ae5221c"
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
