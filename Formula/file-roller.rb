class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/3.38/file-roller-3.38.0.tar.xz"
  sha256 "723d1c6e567d35dad5eeeaeb86b8d18705658ee73e0b3b97ea16adc7a4dc331a"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "5f93b042a4c184676715979ee56beac1eac0d4cf371d314e4746968d5bc163d3" => :big_sur
    sha256 "48e094d70bf4efb02ca607e581c257d78f7da62b287c0293ca141472c70f3e05" => :arm64_big_sur
    sha256 "0bfabe3ee4fcb30fc9b85f98c2c241b625238856c5d9af9fa325cb29bab27de2" => :catalina
    sha256 "fae6eecff0f93c8c033754829e7f8260b3308e9e6f838c80c494aeb6a9b7f9e0" => :mojave
    sha256 "78680c1e5096d8769a9f780c72f0ac3ecc009660085ce8cc29065fd07c1f0e71" => :high_sierra
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "json-glib"
  depends_on "libarchive"
  depends_on "libmagic"

  def install
    ENV.append "CFLAGS", "-I#{Formula["libmagic"].opt_include}"
    ENV.append "LIBS", "-L#{Formula["libmagic"].opt_lib}"

    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = ""
    mkdir "build" do
      system "meson", *std_meson_args, "-Dpackagekit=false", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system bin/"file-roller", "--help"
  end
end
