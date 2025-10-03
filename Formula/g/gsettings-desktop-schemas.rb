class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/49/gsettings-desktop-schemas-49.0.tar.xz"
  sha256 "912905cc45382888a47702ed1101c6b08ebd0122a32a67d940ab8116a96c520d"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "255a40e813d02911612c36c9602cbe065d551e7be32379df9023ad32db901cc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "255a40e813d02911612c36c9602cbe065d551e7be32379df9023ad32db901cc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "255a40e813d02911612c36c9602cbe065d551e7be32379df9023ad32db901cc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "255a40e813d02911612c36c9602cbe065d551e7be32379df9023ad32db901cc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2beaede732944a32b29d9320e49b3f19ceb29d757272b7fec7afc32b57bf7f0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2beaede732944a32b29d9320e49b3f19ceb29d757272b7fec7afc32b57bf7f0b"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"

  def install
    ENV["DESTDIR"] = "/"
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    # manual schema compile step
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gdesktop-enums.h>

      int main(int argc, char *argv[]) {
        return 0;
      }
    C
    system ENV.cc, "-I#{HOMEBREW_PREFIX}/include/gsettings-desktop-schemas", "test.c", "-o", "test"
    system "./test"
  end
end
