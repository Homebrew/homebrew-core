class GtkDoc < Formula
  desc "GTK+ documentation tool"
  homepage "https://www.gtk.org/gtk-doc/"
  url "https://download.gnome.org/sources/gtk-doc/1.26/gtk-doc-1.26.tar.xz"
  sha256 "bff3f44467b1d39775e94fad545f050faa7e8d68dc6a31aef5024ba3c2d7f2b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed1c55f2f8d9e8793e53652f305996c99274750e80d5d3cbaf1cfc6373df64b5" => :sierra
    sha256 "ed1c55f2f8d9e8793e53652f305996c99274750e80d5d3cbaf1cfc6373df64b5" => :el_capitan
    sha256 "ed1c55f2f8d9e8793e53652f305996c99274750e80d5d3cbaf1cfc6373df64b5" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "itstool" => :build
  depends_on "gettext"
  depends_on "docbook"
  depends_on "docbook-xsl"
  depends_on "libxml2"

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resource("six").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-xml-catalog=#{etc}/xml/catalog"
    system "make"
    system "make", "install"

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"gtkdoc-scan", "--module=test"
    system bin/"gtkdoc-mkdb", "--module=test"
  end
end
