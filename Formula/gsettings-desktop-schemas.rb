class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/3.34/gsettings-desktop-schemas-3.34.0.tar.xz"
  sha256 "288b04260f7040b0e004a8d59c773cfb4e32df4f1b4a0f9d705c51afccc95ead"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2873d19eca42edb79cbf3055f0814eb66314edd60df6400ce91a3119661a3a9" => :mojave
    sha256 "b2873d19eca42edb79cbf3055f0814eb66314edd60df6400ce91a3119661a3a9" => :high_sierra
    sha256 "efa60ccb64f70f0a0d0e73df86d3989592205eabaaa186e0d3d50f705cdb27eb" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

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
