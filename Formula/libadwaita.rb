class Libadwaita < Formula
  desc "Building blocks for modern GNOME applications"
  homepage "https://gitlab.gnome.org/GNOME/libadwaita"
  url "https://gitlab.gnome.org/GNOME/libadwaita/-/archive/1.0.0-alpha.1/libadwaita-1.0.0-alpha.1.tar.gz"
  sha256 "15b99dd4116bd0d8c6e98b2ec8867a254cd109d96c112096cf90a8cd5b764e24"
  license "LGPL-2.1-or-later"

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "sassc" => :build
  depends_on "vala" => :build
  depends_on "gtk4"

  def install
    args = std_meson_args + %w[
      -Dtests=false
    ]

    ENV["DESTDIR"] = "/"
    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "#{bin}/adwaita-1-demo", "--help"
  end
end
