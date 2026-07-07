class GraphTool < Formula
  include Language::Python::Virtualenv

  desc "Efficient network analysis for Python 3"
  homepage "https://graph-tool.skewed.de/"
  url "https://downloads.skewed.de/graph-tool/graph-tool-3.0.tar.bz2"
  sha256 "4894d75ee31379d78b5e1d6fb5486ee3d1daecd40d0bd49f5285186dc56882ed"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://downloads.skewed.de/graph-tool/"
    regex(/href=.*?graph-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "4f29bcc01c4eff82e4bad1ff01b17f512c53fe032939130c501984ffb225eae5"
    sha256                               arm64_sequoia: "032459297a538e297adb29dd32c5b570d2df9b39ac0db8b5ebae20a541d7dc60"
    sha256                               arm64_sonoma:  "0271c7776f6e9ef728ea435e0669d23a6e0cf8c6522b79395496556c021490d6"
    sha256                               sonoma:        "9586b5dd993162ca9f75d43bf9a4332767d7ff3f3913fb055b519eca96d8c06e"
    sha256                               arm64_linux:   "18b2deaf9d659b762afcc9dd52742f0b6ee6ccde95ac3ccc491476b8b2683074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fec27dacb1c465b41f64a08336c45dc1e8320521068b4ac0990bf54b4ef806a"
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
  depends_on "python@3.14"
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

  pypi_packages package_name:     "",
                exclude_packages: %w[numpy pillow],
                extra_packages:   %w[matplotlib setuptools zstandard]

  resource "contourpy" do
    url "https://files.pythonhosted.org/packages/58/01/1253e6698a07380cd31a736d248a3f2a50a7c88779a1813da27503cadc2a/contourpy-1.3.3.tar.gz"
    sha256 "083e12155b210502d0bca491432bb04d56dc3432f95a979b429f2848c3dbe880"
  end

  resource "cycler" do
    url "https://files.pythonhosted.org/packages/a9/95/a3dbbb5028f35eafb79008e7522a75244477d2838f38cbb722248dabc2a8/cycler-0.12.1.tar.gz"
    sha256 "88bb128f02ba341da8ef447245a9e138fae777f6a23943da4540077d3601eb1c"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/84/69/c97f2c18e0db87d2c7b15da1974dace76ae938f1cfa22e2727a648b7ed43/fonttools-4.63.0.tar.gz"
    sha256 "caeb583deeb5168e694b65cda8b4ee62abedfa66cf88488734466f2366b9c4e0"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/d0/67/9c61eccb13f0bdca9307614e782fec49ffdde0f7a2314935d489fa93cd9c/kiwisolver-1.5.0.tar.gz"
    sha256 "d4193f3d9dc3f6f79aaed0e5637f45d98850ebf01f7ca20e69457f3e8946b66a"
  end

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/1f/24/080c99d223d158d3a8902769269ab6da5b50f7a0e6e072513907e02b7a6c/matplotlib-3.11.0.tar.gz"
    sha256 "68c0c7be01b30dcca3638934f7f591df73401235cbdbf0d1ab1c71e7db7f8b57"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/34/26/f5d29e25ffdb535afef2d35cdb55b325298f96debd670da4c325e08d70f4/setuptools-83.0.0.tar.gz"
    sha256 "025bccbbf0fa05b6192bc64ae1e7b16e001fd6d6d4d5de03c97b1c1ade523bef"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/fd/aa/3e0508d5a5dd96529cdc5a97011299056e14c6505b678fd58938792794b1/zstandard-0.25.0.tar.gz"
    sha256 "7713e1179d162cf5c7906da876ec2ccb9c3a9dcbdffef0cc7f70c3667a205f0b"
  end

  def python3
    "python3.14"
  end

  # remove obsolete pointer_traits workaround for older libstdc++
  patch :DATA

  def install
    # Work around superenv to avoid mixing `expat` usage in libraries across dependency tree.
    # Brew `expat` usage in Python has low impact as it isn't loaded unless pyexpat is used.
    # TODO: Consider adding a DSL for this or change how we handle Python's `expat` dependency
    if OS.mac? && MacOS.version < :sequoia
      env_vars = %w[CMAKE_PREFIX_PATH HOMEBREW_INCLUDE_PATHS HOMEBREW_LIBRARY_PATHS PATH PKG_CONFIG_PATH]
      ENV.remove env_vars, /(^|:)#{Regexp.escape(formula_opt_prefix("expat"))}[^:]*/
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
      ENV.append "LDFLAGS", "-L#{formula_opt_lib("libomp")} -lomp"
      ENV.append "CPPFLAGS", "-I#{formula_opt_include("libomp")}"
    end

    args = %W[
      PYTHON=#{python}
      --with-python-module-path=#{prefix/site_packages}
      --with-boost-python=boost_python#{xy.to_s.delete(".")}
      --with-boost-libdir=#{formula_opt_lib("boost")}
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
