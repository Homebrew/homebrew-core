class GtkDoc < Formula
  desc "GTK+ documentation tool"
  homepage "https://www.gtk.org/gtk-doc/"
  url "https://download.gnome.org/sources/gtk-doc/1.28/gtk-doc-1.28.tar.xz"
  sha256 "911e29e302252c96128965ee1f4067d5431a88e00ad1023a8bc1d6b922af5715"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "d85ddc463e1e8fea82aa81cd41ea69ae7879dc4493e7bd4b30a58c372233951b" => :mojave
    sha256 "be0ea15d4d139ca270cb09222baed7e0107d5ce406086efe8e849a5b547bb3d0" => :high_sierra
    sha256 "be0ea15d4d139ca270cb09222baed7e0107d5ce406086efe8e849a5b547bb3d0" => :sierra
    sha256 "be0ea15d4d139ca270cb09222baed7e0107d5ce406086efe8e849a5b547bb3d0" => :el_capitan
  end

  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "docbook"
  depends_on "docbook-xsl"
  depends_on "gettext"
  depends_on "libxml2"
  depends_on "python"
  depends_on "source-highlight"

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resource("six").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor")
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
