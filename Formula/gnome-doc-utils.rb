class GnomeDocUtils < Formula
  desc "Documentation utilities for the GNOME project"
  homepage "https://wiki.gnome.org/Projects/GnomeDocUtils"
  url "https://download.gnome.org/sources/gnome-doc-utils/0.20/gnome-doc-utils-0.20.10.tar.xz"
  sha256 "cb0639ffa9550b6ddf3b62f3b1add92fb92ab4690d351f2353cffe668be8c4a6"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "fb74bc752e5fc7cec54ac38ffa995159493be84899cf3aa4adf4791acd6a505b" => :mojave
    sha256 "7f90a3db07a45313f84139a416127d24dc37e2e044841d70f643ec53924eecb3" => :high_sierra
    sha256 "7f90a3db07a45313f84139a416127d24dc37e2e044841d70f643ec53924eecb3" => :sierra
    sha256 "7f90a3db07a45313f84139a416127d24dc37e2e044841d70f643ec53924eecb3" => :el_capitan
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "docbook"
  depends_on "gettext"
  depends_on "libxml2"
  depends_on "python@2"

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
