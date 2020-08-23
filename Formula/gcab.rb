class Gcab < Formula
  desc "Windows installer (.MSI) tool"
  homepage "https://wiki.gnome.org/msitools"
  url "https://download.gnome.org/sources/gcab/1.4/gcab-1.4.tar.xz"
  sha256 "67a5fa9be6c923fbc9197de6332f36f69a33dadc9016a2b207859246711c048f"
  revision 1

  bottle do
    sha256 "7ed919ea9c7d4ec04f9d5f361f8628936e016318475fec26fdf6ef5ea56491cc" => :catalina
    sha256 "c9ef02142502a47b006db735b87fe7d55611d46ecc087c697d3142ce8bd9c27a" => :mojave
    sha256 "ca3d97d649c89be881528e7a7cf42f51c18c3a8e4c4b47c9a5fad29f355afd30" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Ddocs=false", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "#{bin}/gcab", "--version"
  end
end
