class GnomeDocUtils < Formula
  desc "Documentation utilities for the GNOME project"
  homepage "https://wiki.gnome.org/Projects/GnomeDocUtils"
  url "https://download.gnome.org/sources/gnome-doc-utils/0.20/gnome-doc-utils-0.20.10.tar.xz"
  sha256 "cb0639ffa9550b6ddf3b62f3b1add92fb92ab4690d351f2353cffe668be8c4a6"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "50a11122e4fa3f31e1407d36a7e6a64209c4177cef1990935ac34aaf86b8536d" => :high_sierra
    sha256 "d95821cd8f04c592d32de3093662409699c501970fcc05a2df944b28d8925ad4" => :sierra
    sha256 "7a0d8d8881d55aecd4432036f659a9c61e98fa7006afa5ec6bf956b2e34b2c12" => :el_capitan
    sha256 "7a0d8d8881d55aecd4432036f659a9c61e98fa7006afa5ec6bf956b2e34b2c12" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "docbook"
  depends_on "gettext"
  depends_on "libxml2"

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

  test do
    assert_match version.to_s, shell_output("#{bin}/gnome-doc-tool --version")
  end
end
