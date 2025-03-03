class GraphTool < Formula
  include Language::Python::Virtualenv

  desc "Efficient network analysis for Python 3"
  homepage "https://graph-tool.skewed.de/"
  url "https://downloads.skewed.de/graph-tool/graph-tool-2.92.tar.bz2"
  sha256 "041b56a56826655f91f0402ee9e44ead57b78ce4c83437e2f4737964cb79af8e"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://downloads.skewed.de/graph-tool/"
    regex(/href=.*?graph-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_sequoia: "2bd1978b3f33ac8ff24015cb853ffec11ed4249fb347efda0b5ac340e65dc780"
    sha256                               arm64_sonoma:  "dd3496583b016d9b2488c6a0b94be784bc341cb97aab8b059060521bb849db47"
    sha256                               arm64_ventura: "d764891338606d136cb00c38a1a464e77f7d32a9cec66314df66e14a862cb79b"
    sha256                               sonoma:        "b0261a2932bdc498f91f869aedaa6e50a150c4b179318f9d896f4cbc1c2b173f"
    sha256                               ventura:       "494463f895563281bf0724f0c2daf39e0a53e2c9bf5d2f462740741721333525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb5baffcab58223b343388f4805de1c5aea515a6487659471c7e04c7f37174d0"
  end

  depends_on "google-sparsehash" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "boost-python3"
  depends_on "cairomm@1.14"
  depends_on "cgal"
  depends_on "freetype"
  depends_on "gmp"
  depends_on "gtk+3"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.13"
  depends_on "qhull"
  depends_on "scipy"
  depends_on "zstd"

  uses_from_macos "expat"

  on_macos do
    depends_on "cairo"
    depends_on "libomp"
    depends_on "libsigc++@2"
  end

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "contourpy" do
    url "https://files.pythonhosted.org/packages/25/c2/fc7193cc5383637ff390a712e88e4ded0452c9fbcf84abe3de5ea3df1866/contourpy-1.3.1.tar.gz"
    sha256 "dfd97abd83335045a913e3bcc4a09c0ceadbe66580cf573fe961f4a825efa699"
  end

  resource "cycler" do
    url "https://files.pythonhosted.org/packages/a9/95/a3dbbb5028f35eafb79008e7522a75244477d2838f38cbb722248dabc2a8/cycler-0.12.1.tar.gz"
    sha256 "88bb128f02ba341da8ef447245a9e138fae777f6a23943da4540077d3601eb1c"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/1c/8c/9ffa2a555af0e5e5d0e2ed7fdd8c9bef474ed676995bb4c57c9cd0014248/fonttools-4.56.0.tar.gz"
    sha256 "a114d1567e1a1586b7e9e7fc2ff686ca542a82769a296cef131e4c4af51e58f4"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/82/59/7c91426a8ac292e1cdd53a63b6d9439abd573c875c3f92c146767dd33faf/kiwisolver-1.4.8.tar.gz"
    sha256 "23d5f023bdc8c7e54eb65f03ca5d5bb25b601eac4d7f1a042888a1f45237987e"
  end

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/2f/08/b89867ecea2e305f408fbb417139a8dd941ecf7b23a2e02157c36da546f0/matplotlib-3.10.1.tar.gz"
    sha256 "e8d2d0e3881b129268585bf4765ad3ee73a4591d77b9a18c214ac7e3a79fb2ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/8b/1a/3544f4f299a47911c2ab3710f534e52fea62a633c96806995da5d25be4b2/pyparsing-3.2.1.tar.gz"
    sha256 "61980854fd66de3a90028d679a954d5f2623e83144b5afe5ee86f43d762e5f0a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/d1/53/43d99d7687e8cdef5ab5f9ec5eaf2c0423c2b35133a2b7e7bc276fc32b21/setuptools-75.8.2.tar.gz"
    sha256 "4880473a969e5f23f2a2be3646b2dfd84af9028716d398e46192f84bc36900d2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/ed/f6/2ac0287b442160a89d726b17a9184a4c615bb5237db763791a7fd16d9df1/zstandard-0.23.0.tar.gz"
    sha256 "b2d8c62d08e7255f68f7a740bae85b3c9b8e5466baa9cbf7f57f1cde0ac6bc09"
  end

  def python3
    "python3.13"
  end

  # remove obsolete pointer_traits workaround for older libstdc++
  patch :DATA

  def install
    # Work around superenv to avoid mixing `expat` usage in libraries across dependency tree.
    # Brew `expat` usage in Python has low impact as it isn't loaded unless pyexpat is used.
    # TODO: Consider adding a DSL for this or change how we handle Python's `expat` dependency
    if OS.mac? && MacOS.version < :sequoia
      env_vars = %w[CMAKE_PREFIX_PATH HOMEBREW_INCLUDE_PATHS HOMEBREW_LIBRARY_PATHS PATH PKG_CONFIG_PATH]
      ENV.remove env_vars, /(^|:)#{Regexp.escape(Formula["expat"].opt_prefix)}[^:]*/
      ENV.remove "HOMEBREW_DEPENDENCIES", "expat"
    end

    site_packages = Language::Python.site_packages(python3)
    xy = Language::Python.major_minor_version(python3)
    skipped = ["matplotlib", "zstandard"]
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources.reject { |r| skipped.include? r.name }
    python = venv.root/"bin/python"

    resource("matplotlib").stage do
      system python, "-m", "pip", "install", "--config-settings=setup-args=-Dsystem-freetype=true",
                                             "--config-settings=setup-args=-Dsystem-qhull=true",
                                             *std_pip_args(prefix: false, build_isolation: true), "."
    end

    resource("zstandard").stage do
      system python, "-m", "pip", "install", "--config-settings=--build-option=--system-zstd",
                                             *std_pip_args(prefix: false), "."
    end

    # Linux build is not thread-safe.
    ENV.deparallelize unless OS.mac?

    # Enable openmp
    if OS.mac?
      ENV.append_to_cflags "-Xpreprocessor -fopenmp"
      ENV.append "LDFLAGS", "-L#{Formula["libomp"].opt_lib} -lomp"
      ENV.append "CPPFLAGS", "-I#{Formula["libomp"].opt_include}"
    end

    args = %W[
      PYTHON=#{python}
      --with-python-module-path=#{prefix/site_packages}
      --with-boost-python=boost_python#{xy.to_s.delete(".")}
      --with-boost-libdir=#{Formula["boost"].opt_lib}
      --with-boost-coroutine=boost_coroutine
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
    (testpath/"test.py").write <<~PYTHON
      import graph_tool.all as gt
      g = gt.Graph()
      v1 = g.add_vertex()
      v2 = g.add_vertex()
      e = g.add_edge(v1, v2)
      assert g.num_edges() == 1
      assert g.num_vertices() == 2
    PYTHON
    assert_match "Graph drawing will not work", shell_output("#{python3} test.py 2>&1")
    ENV["PYTHONPATH"] = libexec/Language::Python.site_packages(python3)
    refute_match "Graph drawing will not work", shell_output("#{python3} test.py 2>&1")
  end
end

__END__
diff --git a/src/boost-workaround/boost/container/vector_old.hpp b/src/boost-workaround/boost/container/vector_old.hpp
index c4152c8..f72e646 100644
--- a/src/boost-workaround/boost/container/vector_old.hpp
+++ b/src/boost-workaround/boost/container/vector_old.hpp
@@ -3167,20 +3167,6 @@ struct has_trivial_destructor_after_move<boost::container::vector<T, Allocator,

 }

-//See comments on vec_iterator::element_type to know why is this needed
-#ifdef BOOST_GNU_STDLIB
-
-BOOST_MOVE_STD_NS_BEG
-
-template <class Pointer, bool IsConst>
-struct pointer_traits< boost::container::vec_iterator<Pointer, IsConst> >
-   : public boost::intrusive::pointer_traits< boost::container::vec_iterator<Pointer, IsConst> >
-{};
-
-BOOST_MOVE_STD_NS_END
-
-#endif   //BOOST_GNU_STDLIB
-
 #endif   //#ifndef BOOST_CONTAINER_DOXYGEN_INVOKED

 #include <boost/container/detail/config_end.hpp>
