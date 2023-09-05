class GraphTool < Formula
  include Language::Python::Virtualenv

  desc "Efficient network analysis for Python 3"
  homepage "https://graph-tool.skewed.de/"
  url "https://downloads.skewed.de/graph-tool/graph-tool-2.58.tar.bz2"
  sha256 "72a36c3cf17d0f624f093d6d083dd5ecaf040c7022bf332148c772008c987a17"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://downloads.skewed.de/graph-tool/"
    regex(/href=.*?graph-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_ventura:  "3d22ba9c7fbc12ca5c5f2b0652baae1c3d593d5429c12cd98e0f2d64bed4680a"
    sha256                               arm64_monterey: "66143edeae74780601e1c7ab9e9336d26cecaff1197e9a93ec1f12cc4313fd49"
    sha256                               arm64_big_sur:  "1750c37dd98b30b9d363e1bf48dcb612fa7825199fd6a6475e979d03448742ef"
    sha256                               ventura:        "a202ce8154fca7253567eb13ccb932456ac7c1765a80622a2a17f1c511c5c5ab"
    sha256                               monterey:       "9cb51bf45dbc3da60aaef4d29f8fb45807de250a816aed79d5e42c7597f2dfbb"
    sha256                               big_sur:        "e41416cba913a8cc7bbc4d66ee942d88dc6dfb923fae6923b3daa2577c100a70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fff1002f1a1862dc4bc255661f6b388d32720ae110cde5c46e23494900c2b1d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "cairomm@1.14"
  depends_on "cgal"
  depends_on "fonttools"
  depends_on "google-sparsehash"
  depends_on "gtk+3"
  depends_on "librsvg"
  depends_on macos: :mojave # for C++17
  depends_on "numpy"
  depends_on "pillow"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.11"
  depends_on "scipy"
  depends_on "six"

  uses_from_macos "expat" => :build

  # https://git.skewed.de/count0/graph-tool/-/wikis/Installation-instructions#manual-compilation
  fails_with :gcc do
    version "6"
    cause "Requires C++17 compiler"
  end

  # Resources are for Python `matplotlib` and `zstandard` packages

  resource "contourpy" do
    url "https://files.pythonhosted.org/packages/b4/9b/6edb9d3e334a70a212f66a844188fcb57ddbd528cbc3b1fe7abfc317ddd7/contourpy-1.0.7.tar.gz"
    sha256 "d8165a088d31798b59e91117d1f5fc3df8168d8b48c4acc10fc0df0d0bdbcc5e"
  end

  resource "cycler" do
    url "https://files.pythonhosted.org/packages/34/45/a7caaacbfc2fa60bee42effc4bcc7d7c6dbe9c349500e04f65a861c15eb9/cycler-0.11.0.tar.gz"
    sha256 "9c87405839a19696e837b3b818fed3f5f69f16f1eec1a1ad77e043dcea9c772f"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/5f/5c/272a7dd49a1914f35cd8d6d9f386defa8b047f6fbd06badd6b77b3ba24e7/kiwisolver-1.4.4.tar.gz"
    sha256 "d41997519fcba4a1e46eb4a2fe31bc12f0ff957b2b81bac28db24744f333e955"
  end

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/b7/65/d6e00376dbdb6c227d79a2d6ec32f66cfb163f0cd924090e3133a4f85a11/matplotlib-3.7.1.tar.gz"
    sha256 "7b73305f25eab4541bd7ee0b96d87e53ae9c9f1823be5659b806cd85786fe882"

    # fix numpy build issue, https://github.com/matplotlib/matplotlib/issues/26246
    patch :DATA
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/4f/13/28e88033cab976721512e7741000fb0635fa078045e530a91abb25aea0c0/pyparsing-3.1.0.tar.gz"
    sha256 "edb662d6fe322d6e990b1594b5feaeadf806803359e3d4d42f11e295e588f0ea"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/4d/70/1f883646641d7ad3944181549949d146fa19e286e892bc013f7ce1579e8f/zstandard-0.21.0.tar.gz"
    sha256 "f08e3a10d01a247877e4cb61a82a319ea746c356a3786558bed2481e6c405546"
  end

  def python3
    "python3.11"
  end

  def install
    # Linux build is not thread-safe.
    ENV.deparallelize unless OS.mac?

    system "autoreconf", "--force", "--install", "--verbose"
    site_packages = Language::Python.site_packages(python3)
    xy = Language::Python.major_minor_version(python3)
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    %w[fonttools].each do |package_name|
      package = Formula[package_name].opt_libexec
      (libexec/site_packages/"homebrew-#{package_name}.pth").write package/site_packages
    end

    args = %W[
      PYTHON=#{python3}
      --with-python-module-path=#{prefix/site_packages}
      --with-boost-python=boost_python#{xy.to_s.delete(".")}-mt
      --with-boost-libdir=#{Formula["boost"].opt_lib}
      --with-boost-coroutine=boost_coroutine-mt
    ]
    args << "--with-expat=#{MacOS.sdk_path}/usr" if MacOS.sdk_path_if_needed
    args << "PYTHON_LIBS=-undefined dynamic_lookup" if OS.mac?

    system "./configure", *std_configure_args, *args
    system "make", "install"

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
    system python3, "test.py"
  end
end

__END__
diff --git a/pyproject.toml b/pyproject.toml
index 907b05a..81e3d80 100644
--- a/pyproject.toml
+++ b/pyproject.toml
@@ -2,7 +2,7 @@
 build-backend = "setuptools.build_meta"
 requires = [
     "certifi>=2020.06.20",
-    "oldest-supported-numpy",
+    "numpy",
     "pybind11>=2.6",
     "setuptools_scm>=7",
 ]
