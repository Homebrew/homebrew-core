class GraphTool < Formula
  include Language::Python::Virtualenv

  desc "Efficient network analysis for Python 3"
  homepage "https://graph-tool.skewed.de/"
  url "https://downloads.skewed.de/graph-tool/graph-tool-2.98.tar.bz2"
  sha256 "eef1948b937f5f043749eee75fe0c6d7e8f036551d945e9d55e37870b06cc527"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://downloads.skewed.de/graph-tool/"
    regex(/href=.*?graph-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_sequoia: "21f0c2baf5978e40a1852e07d8b69bdbaa4181ab1d977e607fdac50e7e009ff9"
    sha256                               arm64_sonoma:  "0811854443af648bd81e9987e84ba99646360a30a85b6ebf55cb42034ee80939"
    sha256                               arm64_ventura: "ae85d17df47679df7b53fd1e8d8d9b1b5467983c84912855e61724e4ce34a37e"
    sha256                               sonoma:        "33c44673c073b74a5fcf0c7ce881f81ead1db5f128916cb1e8b03f9e6ca743c0"
    sha256                               ventura:       "3a333ca3f5d50bfa91de23bfdc965ece4a1d5be9a8c3f39f8d1fff55df7ae08b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe30f433926f9001935f34f3a3875d0594291ed38a1bc968739850f19659714f"
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
    url "https://files.pythonhosted.org/packages/58/01/1253e6698a07380cd31a736d248a3f2a50a7c88779a1813da27503cadc2a/contourpy-1.3.3.tar.gz"
    sha256 "083e12155b210502d0bca491432bb04d56dc3432f95a979b429f2848c3dbe880"
  end

  resource "cycler" do
    url "https://files.pythonhosted.org/packages/a9/95/a3dbbb5028f35eafb79008e7522a75244477d2838f38cbb722248dabc2a8/cycler-0.12.1.tar.gz"
    sha256 "88bb128f02ba341da8ef447245a9e138fae777f6a23943da4540077d3601eb1c"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/11/7f/29c9c3fe4246f6ad96fee52b88d0dc3a863c7563b0afc959e36d78b965dc/fonttools-4.59.1.tar.gz"
    sha256 "74995b402ad09822a4c8002438e54940d9f1ecda898d2bb057729d7da983e4cb"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/5c/3c/85844f1b0feb11ee581ac23fe5fce65cd049a200c1446708cc1b7f922875/kiwisolver-1.4.9.tar.gz"
    sha256 "c3b22c26c6fd6811b0ae8363b95ca8ce4ea3c202d3d0975b2914310ceb1bcc4d"
  end

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/43/91/f2939bb60b7ebf12478b030e0d7f340247390f402b3b189616aad790c366/matplotlib-3.10.5.tar.gz"
    sha256 "352ed6ccfb7998a00881692f38b4ca083c691d3e275b4145423704c34c909076"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/bb/22/f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60f/pyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/09/1b/c20b2ef1d987627765dcd5bf1dadb8ef6564f00a87972635099bb76b7a05/zstandard-0.24.0.tar.gz"
    sha256 "fe3198b81c00032326342d973e526803f183f97aa9e9a98e3f897ebafe21178f"
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
