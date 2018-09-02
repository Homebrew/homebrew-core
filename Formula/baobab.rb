class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/3.30/baobab-3.30.0.tar.xz"
  sha256 "5e4dd06f241eb32f00850efa1a4541cee088de480be2b52d788143187410a74f"

  bottle do
    cellar :any
    sha256 "82714fced60aab9783af682b720830e4b0bed8b4cfb816372f387ac3d41cb715" => :mojave
    sha256 "df91083504c615b21a90f0d1a8ec164f711fa336c5884feec211ac46678aee32" => :high_sierra
    sha256 "1e5b3391a333627116594477b5fe8a8bc8348312f84a518a757f53b1d12a89cb" => :sierra
    sha256 "6b271f297efc4b0e0c27537b2334f3aff80e8a3ac4486c5abfe48737ab4f2251" => :el_capitan
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@2" => :build
  depends_on "itstool" => :build
  depends_on "vala" => :build
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "adwaita-icon-theme"

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
