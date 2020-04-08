class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/3.36/gsettings-desktop-schemas-3.36.0.tar.xz"
  sha256 "764ab683286536324533a58d4e95fc57f81adaba7d880dd0ebbbced63e960ea6"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "2fddc49ef9d3b064f1663d98c34a7c9b042dd529da8eb02b490aad3fde21775e" => :catalina
    sha256 "2fddc49ef9d3b064f1663d98c34a7c9b042dd529da8eb02b490aad3fde21775e" => :mojave
    sha256 "2fddc49ef9d3b064f1663d98c34a7c9b042dd529da8eb02b490aad3fde21775e" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on "glib"

  uses_from_macos "expat"

  def install
    ENV["DESTDIR"] = "/"

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
