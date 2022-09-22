class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://gitlab.gnome.org/GNOME/gucharmap/-/archive/15.0.0/gucharmap-15.0.0.tar.bz2"
  sha256 "c85c1554923df5028de1247bbba782e61ba15f2d21a711a68b23cd3a35788c97"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "04be31ca892b6d00aabe5025063abb525630883ff1dd1a99f4f6fc1e8de48802"
    sha256 arm64_big_sur:  "f96625e52ea9855f9d4f350e0e61cbc90c352dfd76931dff3fc3503810be0118"
    sha256 monterey:       "739f55d1ebe5cb2bbd1cb3e414c9e0e01f6f7d2172aa2cb858e016340da875ea"
    sha256 big_sur:        "318ada0ffb5e2b9a2c4ed5968f8d38762a4cc2bb7119e50d6bb13354ca1de47f"
    sha256 catalina:       "007a3670270b9b8cbc2e0e9f36cb3854ba987d8b8105ec73e236fc56d28c2cbe"
    sha256 mojave:         "b8f34cbea2db76364e0a4e3a6d2e5ba3110e80ef6b76fa3c165b1ac6b30ee9f1"
    sha256 high_sierra:    "f8ad1728dd1e0124201e568ad0f69f004245368eb21527dea98ecf045ccad708"
    sha256 x86_64_linux:   "6604c5046dbae96f07f30c6e4ee45c9b2e6e5a1030ae44c5dcd03870361c8fc4"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gtk+3"

  resource "ucd" do
    url "https://www.unicode.org/Public/15.0.0/ucd/UCD.zip"
    sha256 "5fbde400f3e687d25cc9b0a8d30d7619e76cb2f4c3e85ba9df8ec1312cb6718c"
  end

  resource "unihan" do
    url "https://www.unicode.org/Public/15.0.0/ucd/Unihan.zip", using: :nounzip
    sha256 "24b154691fc97cb44267b925d62064297086b3f896b57a8181c7b6d42702a026"
  end

  def install
    ENV["DESTDIR"] = "/"
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    (buildpath/"unicode").install resource("ucd")
    (buildpath/"unicode").install resource("unihan")

    # ERROR: Assert failed: -Wl,-Bsymbolic-functions is required but not supported
    inreplace "meson.build", "'-Wl,-Bsymbolic-functions'", "" if OS.mac?

    system "meson", *std_meson_args, "build", "-Ducd_path=#{buildpath}/unicode"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system "#{bin}/gucharmap", "--version"
  end
end
