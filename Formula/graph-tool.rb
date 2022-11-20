class GraphTool < Formula
  include Language::Python::Virtualenv

  desc "Efficient network analysis for Python 3"
  homepage "https://graph-tool.skewed.de/"
  url "https://downloads.skewed.de/graph-tool/graph-tool-2.45.tar.bz2"
  sha256 "f92da7accfda02b29791efe4f0b3ed93329f27232af4d3afc07c92421ec68668"
  license "LGPL-3.0-or-later"
  revision 4

  livecheck do
    url "https://downloads.skewed.de/graph-tool/"
    regex(/href=.*?graph-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_ventura:  "0e5113457b48f829a823a2c27861937ed5ba3de48f02f20a73f934e84292df20"
    sha256                               arm64_monterey: "72e51d21086a0f978b353bbf0eb273af83e10ed400df7272d282a3c810c96b73"
    sha256                               arm64_big_sur:  "3b393a7329669564548d8edff26b613b85eb7209f952a14ed0e9c00bfff18784"
    sha256                               ventura:        "5b7ae782226e371e57023a39b1b344187aa71de5c0d539f753811d0491bb9022"
    sha256                               monterey:       "7f2394b7289eecc174e821204f41e756b7bc0b7070c14ef4dfe6ad671718482a"
    sha256                               big_sur:        "912a5656461297bc57424f50258c64ef69ec6215b40e2e4ae538122d822e65cc"
    sha256                               catalina:       "8eeb0ebb043660d3bf1ef17a8930050d992dd51084d86ac140c2b6f2b3431ec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b1aad1b1afa533bfe5e6a88bedc7ac876cfb67d76fcc6066a85b2fb6686fe4e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "cairomm@1.14"
  depends_on "cgal"
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
    url "https://files.pythonhosted.org/packages/8f/4f/8a5789867f2a928fd9b32e7e8d4bc0f27a765aa7056989e7427f2c2a1966/contourpy-1.0.6.tar.gz"
    sha256 "6e459ebb8bb5ee4c22c19cc000174f8059981971a33ce11e17dddf6aca97a142"
  end

  resource "cycler" do
    url "https://files.pythonhosted.org/packages/34/45/a7caaacbfc2fa60bee42effc4bcc7d7c6dbe9c349500e04f65a861c15eb9/cycler-0.11.0.tar.gz"
    sha256 "9c87405839a19696e837b3b818fed3f5f69f16f1eec1a1ad77e043dcea9c772f"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/55/5c/a4a25cf6db42d113d8f626901bb156b2f7cf7c7564a6bbc7b5cd6f7cb484/fonttools-4.38.0.zip"
    sha256 "2bb244009f9bf3fa100fc3ead6aeb99febe5985fa20afbfbaa2f8946c2fbdaf1"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/5f/5c/272a7dd49a1914f35cd8d6d9f386defa8b047f6fbd06badd6b77b3ba24e7/kiwisolver-1.4.4.tar.gz"
    sha256 "d41997519fcba4a1e46eb4a2fe31bc12f0ff957b2b81bac28db24744f333e955"
  end

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/91/1c/a48fd779287df3425c289cc2ff728980a5b355f15f4c3c40e1822770ba44/matplotlib-3.6.2.tar.gz"
    sha256 "b03fd10a1709d0101c054883b550f7c4c5e974f751e2680318759af005964990"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
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
    url "https://files.pythonhosted.org/packages/9a/50/1b7f7f710c0dfc1019ec4c7295f67855722c342af82f3132664ca6dc1c07/zstandard-0.19.0.tar.gz"
    sha256 "31d12fcd942dd8dbf52ca5f6b1bbe287f44e5d551a081a983ff3ea2082867863"
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
      import graph_tool as gt
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
