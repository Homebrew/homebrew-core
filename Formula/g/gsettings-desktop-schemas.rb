class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/46/gsettings-desktop-schemas-46.1.tar.xz"
  sha256 "9b88101437a6958ebe6bbd812e49bbf1d09cc667011e415559d847e870468a61"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a82b0432199990863ffb3e96bbc34dcd9c534105a13b42efc5e66aaa3c2019eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a82b0432199990863ffb3e96bbc34dcd9c534105a13b42efc5e66aaa3c2019eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a82b0432199990863ffb3e96bbc34dcd9c534105a13b42efc5e66aaa3c2019eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "a82b0432199990863ffb3e96bbc34dcd9c534105a13b42efc5e66aaa3c2019eb"
    sha256 cellar: :any_skip_relocation, ventura:        "a82b0432199990863ffb3e96bbc34dcd9c534105a13b42efc5e66aaa3c2019eb"
    sha256 cellar: :any_skip_relocation, monterey:       "a82b0432199990863ffb3e96bbc34dcd9c534105a13b42efc5e66aaa3c2019eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "872eb6f9edaf59999a3fb88a29133ca93eac0c4561a54fe7b84686bf3e1fb381"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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
    (testpath/"test.c").write <<~EOS
      #include <gdesktop-enums.h>

      int main(int argc, char *argv[]) {
        return 0;
      }
    EOS
    system ENV.cc, "-I#{HOMEBREW_PREFIX}/include/gsettings-desktop-schemas", "test.c", "-o", "test"
    system "./test"
  end
end
