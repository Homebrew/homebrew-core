class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/3.38/baobab-3.38.0.tar.xz"
  sha256 "048468147860816b97f15d50b3c84e9acf0539c1441cfeb63703d112e8728329"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "4a9d7b940b8d32bea12f03e4dde9c834a1efd60bcae26bc8dfce82784dee1183" => :big_sur
    sha256 "900fff026ec24002744ec2f9836c55614f5d9a775cb562d38fcd883871ea69b0" => :arm64_big_sur
    sha256 "433a0bd533b88a32c6a860776c1979a9d4face3db73d7011cef2f444bcbc033b" => :catalina
    sha256 "b1043ff9f9bd7edb169a955fe4eaccc521dcf95a448d3a52aed4b79a8eb982f9" => :mojave
    sha256 "9768e9d8d1f4fdcc0a0fbb5936183c1f0bff547e34fc9814f38698e0e3da2f55" => :high_sierra
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"

  def install
    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/baobab --version")
  end
end
