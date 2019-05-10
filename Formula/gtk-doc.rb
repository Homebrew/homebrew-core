class GtkDoc < Formula
  desc "GTK+ documentation tool"
  homepage "https://www.gtk.org/gtk-doc/"
  url "https://download.gnome.org/sources/gtk-doc/1.30/gtk-doc-1.30.tar.xz"
  sha256 "a4f6448eb838ccd30d76a33b1fd095f81aea361f03b12c7b23df181d21b7069e"

  bottle do
    cellar :any_skip_relocation
    sha256 "5bfa35893a46bdeea964ce40df94ffd8e0ecd6a07087eed076de9c00a8a26bcf" => :mojave
    sha256 "5bfa35893a46bdeea964ce40df94ffd8e0ecd6a07087eed076de9c00a8a26bcf" => :high_sierra
    sha256 "7e165fbe563ec90947e6e6917344fd48f3109afe716eac72fdfe3b738a852c6b" => :sierra
  end

  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "docbook"
  depends_on "docbook-xsl"
  depends_on "gettext"
  depends_on "libxml2"
  depends_on "python"
  depends_on "source-highlight"

  def install
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
