class GtkDoc < Formula
  desc "GTK+ documentation tool"
  homepage "https://www.gtk.org/gtk-doc/"
  url "https://download.gnome.org/sources/gtk-doc/1.27/gtk-doc-1.27.tar.xz"
  sha256 "e26bd3f7080c749b1cb66c46c6bf8239e2f320a949964fb9c6d56e1b0c6d9a6f"

  bottle do
    cellar :any_skip_relocation
    sha256 "f479ba17889e905cceea6e0a0c5cda20ddab85e506089a6eb1fb1a0827537055" => :high_sierra
    sha256 "f479ba17889e905cceea6e0a0c5cda20ddab85e506089a6eb1fb1a0827537055" => :sierra
    sha256 "f479ba17889e905cceea6e0a0c5cda20ddab85e506089a6eb1fb1a0827537055" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "itstool" => :build
  depends_on "gettext"
  depends_on "docbook"
  depends_on "docbook-xsl"
  depends_on "libxml2"
  depends_on "source-highlight"

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
                          "--with-highlight=source-highlight",
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
