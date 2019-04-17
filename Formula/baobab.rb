class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/3.32/baobab-3.32.0.tar.xz"
  sha256 "39414ce94045b35768acddf72d341e7d436cd71298994379d9cec50b57d2632c"

  bottle do
    sha256 "a2233e0b2768ba29da4f506d2e958b51eec2edff278ec1fcbae4d0e4e249d519" => :mojave
    sha256 "ffc832dfb526bdb31b9495f6b06b827b3df5c86005971f4c5da95e6a0212c2b3" => :high_sierra
    sha256 "1cec7d1d5eb4dc3b7a411fe3fcca4cdfca3a0b281f5f62ed9a9f681a24231500" => :sierra
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"

  def install
    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
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
