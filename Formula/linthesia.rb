class Linthesia < Formula
  desc "Synthesia-like software for Linux"
  homepage "http://linthesia.sourceforge.net/"
  url "https://github.com/linthesia/linthesia/archive/refs/tags/0.8.0.tar.gz"
  sha256 "0bbfeb30909fbd3a3b33bc45e8f7e75944ba6b2135a627d5729f4bda50540027"
  license "GPL-2.0-only"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gsettings-desktop-schemas" => :build

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    system Formula["gtk+3"].opt_bin/"gtk3-update-icon-cache", "-qtf", HOMEBREW_PREFIX/"share/icons/hicolor"
  end

  test do
    system bin/"linthesia", "--version"
  end
end
