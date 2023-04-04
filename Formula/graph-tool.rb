class GraphTool < Formula
  include Language::Python::Virtualenv

  desc "Efficient network analysis for Python 3"
  homepage "https://graph-tool.skewed.de/"
  url "https://downloads.skewed.de/graph-tool/graph-tool-2.49.tar.bz2"
  sha256 "8a3e943e461d38e0dec1512c4aa0ee02fff4502935a41346c030799eca484990"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://downloads.skewed.de/graph-tool/"
    regex(/href=.*?graph-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_ventura:  "db2fc2cfbbcd57be464cde5ee0e3f4e7d2652cb3476a4386dfe0c27c232325e5"
    sha256                               arm64_monterey: "85935f0a2b2fa0dbf7ba220e80d3553ccaa25ae04530cf110041f16be54ddb31"
    sha256                               arm64_big_sur:  "785faa87e9bd48303e865482a7f037a0a9fff760dbc72b1755182e00a41cc9a0"
    sha256                               ventura:        "7b66512963adf532295b2b598f12da5d2ed7fcdc3edf6b5fa6f6e836a0e67b90"
    sha256                               monterey:       "7f5e839ae9069e900b3b64d6979bb8638340269675e27c8471098e2d37ea8b19"
    sha256                               big_sur:        "0b985748fef4877bb3e9313fcaf8d2cee8d9a5c27aaeb70ef1ff00d77b6f8e0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "993fa1cc75985e4ed0d37cc696cb447bf86f24333d7b2e546e8c838e6f15efdd"
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
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/02/f8/9ee010452d7be18c699ddc598237b52215966220401289c66b7897c7ecfb/zstandard-0.20.0.tar.gz"
    sha256 "613daadd72c71b1488742cafb2c3b381c39d0c9bb8c6cc157aa2d5ea45cc2efc"
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
