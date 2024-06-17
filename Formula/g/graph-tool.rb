class GraphTool < Formula
  include Language::Python::Virtualenv

  desc "Efficient network analysis for Python 3"
  homepage "https://graph-tool.skewed.de/"
  # TODO: Update build for matplotlib>=3.9.0 to use `--config-settings=setup-args=...` for system dependencies
  url "https://downloads.skewed.de/graph-tool/graph-tool-2.70.tar.bz2"
  sha256 "86884680e9f13f59dbf0d7e40d160f274f2cc74107f0fc57ed16e59353cb9489"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://downloads.skewed.de/graph-tool/"
    regex(/href=.*?graph-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "430def229b7838cced90839c171605a47d6715b8942cedc60019fb45b3fce95e"
    sha256                               arm64_ventura:  "5eb2c4375e8d2356bf47defa9377f1a86c2628449d0e52ffe1698fdbe5626847"
    sha256                               arm64_monterey: "c635fb2ca83bf87d3c134f1dd69bd2f5d160a2854d58441d0cbeca648388feac"
    sha256                               sonoma:         "60c583a90c410762c2e06f14d359df3a45a1038eb8c7a243efbf50c844c0ec95"
    sha256                               ventura:        "944352f63bfbfb07b84c055bbba036cd3b44b9d180d8089b200b1f5863b52679"
    sha256                               monterey:       "63dbca4c6d7b2a2940c5baea929e19786f11d65848d896a8578af608260219e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cc58b0aab9f78bbc8545b5e016ce29adbaf66c3c1e9036164cec0b23c2228b5"
  end

  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "cairomm@1.14"
  depends_on "cgal"
  depends_on "freetype"
  depends_on "gmp"
  depends_on "google-sparsehash"
  depends_on "gtk+3"
  depends_on macos: :mojave # for C++17
  depends_on "numpy"
  depends_on "pillow"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.12"
  depends_on "qhull"
  depends_on "scipy"
  depends_on "zstd"

  uses_from_macos "expat"

  on_macos do
    depends_on "cairo"
    depends_on "libsigc++@2"
  end

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "contourpy" do
    url "https://files.pythonhosted.org/packages/8d/9e/e4786569b319847ffd98a8326802d5cf8a5500860dbfc2df1f0f4883ed99/contourpy-1.2.1.tar.gz"
    sha256 "4d8908b3bee1c889e547867ca4cdc54e5ab6be6d3e078556814a22457f49423c"
  end

  resource "cycler" do
    url "https://files.pythonhosted.org/packages/a9/95/a3dbbb5028f35eafb79008e7522a75244477d2838f38cbb722248dabc2a8/cycler-0.12.1.tar.gz"
    sha256 "88bb128f02ba341da8ef447245a9e138fae777f6a23943da4540077d3601eb1c"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/a4/6e/681d39b71d5f0d6a1b1dc87d7333331f9961b5ab6a2ad6372d6cf3f8b04c/fonttools-4.53.0.tar.gz"
    sha256 "c93ed66d32de1559b6fc348838c7572d5c0ac1e4a258e76763a5caddd8944002"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/b9/2d/226779e405724344fc678fcc025b812587617ea1a48b9442628b688e85ea/kiwisolver-1.4.5.tar.gz"
    sha256 "e57e563a57fb22a142da34f38acc2fc1a5c864bc29ca1517a88abc963e60d6ec"
  end

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/c5/a4/a7236bf8b0137deff48737c6ccf2154ef4486e57c6a5b7c309bf515992bd/matplotlib-3.9.0.tar.gz"
    sha256 "e6d29ea6c19e34b30fb7d88b7081f869a03014f66fe06d62cc77d5a6ea88ed7a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/46/3a/31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842/pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/aa/60/5db2249526c9b453c5bb8b9f6965fcab0ddb7f40ad734420b3b421f7da44/setuptools-70.0.0.tar.gz"
    sha256 "f211a66637b8fa059bb28183da127d4e86396c991a942b028c6650d4319c3fd0"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/5d/91/2162ab4239b3bd6743e8e407bc2442fca0d326e2d77b3f4a88d90ad5a1fa/zstandard-0.22.0.tar.gz"
    sha256 "8226a33c542bcb54cd6bd0a366067b610b41713b64c9abec1bc4533d69f51e70"
  end

  def python3
    "python3.12"
  end

  def install
    # https://github.com/matplotlib/matplotlib/blob/v3.8.3/doc/users/installing/dependencies.rst
    ENV["MPLSETUPCFG"] = buildpath/"mplsetup.cfg"
    (buildpath/"mplsetup.cfg").write <<~EOS
      [libs]
      system_freetype = true
      system_qhull = true
    EOS

    site_packages = Language::Python.site_packages(python3)
    xy = Language::Python.major_minor_version(python3)
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources.reject { |r| r.name == "zstandard" }
    resource("zstandard").stage do
      system_zstd_arg = "--config-settings=--build-option=--system-zstd"
      system venv.root/"bin/python3", "-m", "pip", "install", system_zstd_arg, *std_pip_args, "."
    end

    # Linux build is not thread-safe.
    ENV.deparallelize unless OS.mac?

    args = %W[
      PYTHON=#{venv.root}/bin/python
      --with-python-module-path=#{prefix/site_packages}
      --with-boost-python=boost_python#{xy.to_s.delete(".")}-mt
      --with-boost-libdir=#{Formula["boost"].opt_lib}
      --with-boost-coroutine=boost_coroutine-mt
      --disable-silent-rules
    ]
    args << "PYTHON_LIBS=-undefined dynamic_lookup" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      Only the main library is linked to avoid contaminating the shared site-packages.
      Graph drawing and other features that require extra Python packages may be used
      by adding the following formula-specific site-packages to your PYTHONPATH:
        #{opt_libexec/Language::Python.site_packages(python3)}
    EOS
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
    assert_match "Graph drawing will not work", shell_output("#{python3} test.py 2>&1")
    ENV["PYTHONPATH"] = libexec/Language::Python.site_packages(python3)
    refute_match "Graph drawing will not work", shell_output("#{python3} test.py 2>&1")
  end
end
