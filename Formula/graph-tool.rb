class GraphTool < Formula
  include Language::Python::Virtualenv

  desc "Efficient network analysis for Python 3"
  homepage "https://graph-tool.skewed.de/"
  url "https://downloads.skewed.de/graph-tool/graph-tool-2.27.tar.bz2"
  sha256 "4740c69720dfbebf8fb3e77057b3e6a257ccf0432cdaf7345f873247390e4313"
  revision 1

  bottle do
    sha256 "8f1261b33f8270e9a2be5a930de38bcef4bcdbd749b7051d494c05024cfe1971" => :high_sierra
    sha256 "271aaced63f2801e7508913dfce5a937de2f99c9e0635e20afd5101192553ed4" => :sierra
    sha256 "53bcbcfac18b123cf923a1711eac3d1160515b0fd8652a7fa14234ea461b0d2e" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "cairomm"
  depends_on "cgal"
  depends_on "google-sparsehash"
  depends_on "gtk+3"
  depends_on "librsvg"
  depends_on :macos => :el_capitan # needs thread-local storage
  depends_on "numpy"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python"
  depends_on "scipy"

  # Python 3.7 compat
  patch :DATA

  resource "Cycler" do
    url "https://files.pythonhosted.org/packages/c2/4b/137dea450d6e1e3d474e1d873cd1d4f7d3beed7e0dc973b06e8e10d32488/cycler-0.10.0.tar.gz"
    sha256 "cd7b2d1018258d7247a71425e9f26463dfb444d411c39569972f4ce586b0c9d8"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/31/60/494fcce70d60a598c32ee00e71542e52e27c978e5f8219fae0d4ac6e2864/kiwisolver-1.0.1.tar.gz"
    sha256 "ce3be5d520b4d2c3e5eeb4cd2ef62b9b9ab8ac6b6fedbaa0e39cdb6f50644278"
  end

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/ec/ed/46b835da53b7ed05bd4c6cae293f13ec26e877d2e490a53a709915a9dcb7/matplotlib-2.2.2.tar.gz"
    sha256 "4dc7ef528aad21f22be85e95725234c5178c0f938e2228ca76640e5e84d8cde8"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz"
    sha256 "0832bcf47acd283788593e7a0f542407bd9550a55a8a8435214a1960e04bcb04"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/a0/b0/a4e3241d2dee665fea11baec21389aec6886655cd4db7647ddf96c3fad15/python-dateutil-2.7.3.tar.gz"
    sha256 "e27001de32f627c22380a688bcc43ce83504a7bc5da472209b4c70f02829f0b8"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/10/76/52efda4ef98e7544321fd8d5d512e11739c1df18b0649551aeccfb1c8376/pytz-2018.4.tar.gz"
    sha256 "c06425302f2cf668f1bba7a0a03f3c1d34d4ebeef2c72003da308b3947c7f749"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    xy = Language::Python.major_minor_version "python3"

    venv = virtualenv_create(libexec, "python3")

    resources.each do |r|
      venv.pip_install_and_link r
    end

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "PYTHON=python3",
                          "PYTHON_LIBS=-undefined dynamic_lookup",
                          "--with-python-module-path=#{lib}/python#{xy}/site-packages",
                          "--with-boost-python=boost_python#{xy.to_s.delete(".")}-mt"
    system "make", "install"

    site_packages = "lib/python#{xy}/site-packages"
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-graph-tool.pth").write pth_contents
  end

  test do
    (testpath/"test.py").write <<~EOS
      import graph_tool.all as gt
      g = gt.Graph()
      v1 = g.add_vertex()
      v2 = g.add_vertex()
      e = g.add_edge(v1, v2)
      assert g.num_edges() == 1
      assert g.num_vertices() == 2
    EOS
    system "python3", "test.py"
  end
end

__END__
diff --git a/src/graph_tool/draw/gtk_draw.py b/src/graph_tool/draw/gtk_draw.py
index 9f60075..c65bc32 100644
--- a/src/graph_tool/draw/gtk_draw.py
+++ b/src/graph_tool/draw/gtk_draw.py
@@ -1182,7 +1182,7 @@ _window_list = []
 
 def interactive_window(g, pos=None, vprops=None, eprops=None, vorder=None,
                        eorder=None, nodesfirst=False, geometry=(500, 400),
-                       update_layout=True, async=False, no_main=False, **kwargs):
+                       update_layout=True, async_=False, no_main=False, **kwargs):
     r"""
     Display an interactive GTK+ window containing the given graph.
 
@@ -1244,7 +1244,7 @@ def interactive_window(g, pos=None, vprops=None, eprops=None, vorder=None,
     win.show_all()
     _window_list.append(win)
     if not no_main:
-        if async:
+        if async_:
             # just a placeholder for a proper main loop integration with gtk3 when
             # ipython implements it
             import IPython.lib.inputhook
