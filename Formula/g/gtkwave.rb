class Gtkwave < Formula
  desc "GTK-based wave viewer for viewing VCD, GHW, FST, and other waveform files"
  homepage "https://gtkwave.github.io/gtkwave/"
  url "https://github.com/gtkwave/gtkwave/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "d5558cd419c8d46bdc958064cb97f963d1ea793866414c025906ec15033512ed"
  license "GPL-2.0-or-later"
  head "https://github.com/gtkwave/gtkwave.git", branch: "master"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "gtk4"

  on_macos do
    depends_on "gtk-mac-integration"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"gtkwave", "--version"
  end
end
