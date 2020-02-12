class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/3.34/gsettings-desktop-schemas-3.34.0.tar.xz"
  sha256 "288b04260f7040b0e004a8d59c773cfb4e32df4f1b4a0f9d705c51afccc95ead"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "25c76bffef3120c933377a4fb15c83e58e85725cddf5eb5a0b258543dca236b5" => :catalina
    sha256 "b4ee2623616015199defc0693af6a1b5ca5e33db176057f0c45c831463e73dce" => :mojave
    sha256 "b4ee2623616015199defc0693af6a1b5ca5e33db176057f0c45c831463e73dce" => :high_sierra
    sha256 "6c01b5599386af810b7bac0b6c4b8f2bf985a4d649e8d98c674097052a570a8f" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "python"

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
