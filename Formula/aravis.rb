class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://github.com/AravisProject/aravis/releases/download/0.8.24/aravis-0.8.24.tar.xz"
  sha256 "0c9b04427fe54f5b18e7add6d5b703c1389ec7f6a06626eb43fdfd8255b399a5"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "9701d1ad7e7930e0ab5c4f4c609f6b6b1c94456ca844fddd4453c32daefcf755"
    sha256 arm64_monterey: "a70848acc61192b1883444a3836b5af01ae14e14368623e9072885d192d204e0"
    sha256 arm64_big_sur:  "1f3de823aa41278732508d9cf833ecb916babcca87030b688693cbd238c85779"
    sha256 ventura:        "91767d25ecd620ec764d49c8deacbb99ef3e3afae6945050ee45224212f7e2ba"
    sha256 monterey:       "5b14fbff5048018efab41f2736bf88113ccee18714f3b2c4b8c8103a9e548c4b"
    sha256 big_sur:        "8026a50067b5b7833e18154b9ef1991be71953233dd86f8d1cb2e7c20062f95a"
    sha256 x86_64_linux:   "5b35f9da04c07234a08e0598e5f3c811378d3b1a46f414ba360d68b5e3284710"
  end

  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "glib"
  depends_on "gst-plugins-bad"
  depends_on "gst-plugins-base"
  depends_on "gst-plugins-good"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "intltool"
  depends_on "libnotify"
  depends_on "libusb"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    lib_ext = OS.mac? ? "dylib" : "so"
    output = shell_output("gst-inspect-1.0 #{lib}/gstreamer-1.0/libgstaravis.#{version.major_minor}.#{lib_ext}")
    assert_match(/Description *Aravis Video Source/, output)
  end
end
