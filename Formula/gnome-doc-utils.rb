class GnomeDocUtils < Formula
  desc "Documentation utilities for the GNOME project"
  homepage "https://live.gnome.org/GnomeDocUtils"
  url "https://download.gnome.org/sources/gnome-doc-utils/0.20/gnome-doc-utils-0.20.10.tar.xz"
  sha256 "cb0639ffa9550b6ddf3b62f3b1add92fb92ab4690d351f2353cffe668be8c4a6"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "dd60bea34848049cef5c065cfd329428fbd1aca0375e65a5c50ef424a8cd8205" => :sierra
    sha256 "dd60bea34848049cef5c065cfd329428fbd1aca0375e65a5c50ef424a8cd8205" => :el_capitan
    sha256 "dd60bea34848049cef5c065cfd329428fbd1aca0375e65a5c50ef424a8cd8205" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on :python
  depends_on "docbook"
  depends_on "gettext"
  depends_on "libxml2" => "with-python"

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"

    system "./configure", "--prefix=#{prefix}",
                          "--disable-scrollkeeper",
                          "--enable-build-utils=yes"

    # Compilation doesn't work right if we jump straight to make install
    system "make"
    system "make", "install"
  end
end
