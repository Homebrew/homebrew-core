class GraphTool < Formula
  include Language::Python::Virtualenv

  desc "Efficient network analysis for Python 3"
  homepage "https://graph-tool.skewed.de/"
  url "https://downloads.skewed.de/graph-tool/graph-tool-2.98.tar.bz2"
  sha256 "eef1948b937f5f043749eee75fe0c6d7e8f036551d945e9d55e37870b06cc527"
  license "LGPL-3.0-or-later"
  revision 4

  livecheck do
    url "https://downloads.skewed.de/graph-tool/"
    regex(/href=.*?graph-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256               arm64_tahoe:   "6afb00c1f7d70785dc11cee93c8e1737cb2d5418fe3277fa21bc82fada367d88"
    sha256               arm64_sequoia: "6145b7a963a4d27c599e8f178bac270735416155fa8927a17ccdad5d89d54c41"
    sha256               arm64_sonoma:  "b56bc924ea55f7c925469ffd2c1749f69c9c9ad5d27e7769ef6b619b43ac408c"
    sha256               sonoma:        "ce2bccff3d23b5c7a5f26306a47104c1d0c5566fbf6bf84ee5f7e1e4b43ff592"
    sha256               arm64_linux:   "500f1643dbc65fc8c035570ebb5cb2645f4b8f5f19206515bb0ce75436664e2c"
    sha256 cellar: :any, x86_64_linux:  "aacef17c2a0dd105ba0b6e380bba2149d431212e44324949c4149e92cf60c8a3"
  end

  depends_on "cgal" => :build
  depends_on "google-sparsehash" => :build # TODO: Remove in 3.x
  depends_on "pkgconf" => :build
  depends_on "py3cairo" => [:build, :test]
  depends_on "python-setuptools" => :build # for zstandard

  # only test optional graph drawing feature to reduce required runtime dependencies
  depends_on "gtk+3" => :test
  depends_on "pygobject3" => :test
  depends_on "python-matplotlib" => :test

  depends_on "boost"
  depends_on "boost-python3"
  depends_on "cairomm"
  depends_on "gmp"
  depends_on "numpy" => :no_linkage
  depends_on "python@3.14"
  depends_on "scipy" => :no_linkage
  depends_on "zstd"

  uses_from_macos "expat"

  on_macos do
    depends_on "cairo"
    depends_on "libomp"
    depends_on "libsigc++"
  end

  pypi_packages package_name:   "",
                extra_packages: "zstandard"

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/fd/aa/3e0508d5a5dd96529cdc5a97011299056e14c6505b678fd58938792794b1/zstandard-0.25.0.tar.gz"
    sha256 "7713e1179d162cf5c7906da876ec2ccb9c3a9dcbdffef0cc7f70c3667a205f0b"
  end

  def python3 = "python3.14"

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

    venv = virtualenv_create(libexec, python3)
    resource("zstandard").stage do
      args = ["--config-settings=--build-option=--system-zstd"]
      system venv.root/"bin/python", "-m", "pip", "install", *args, *std_pip_args(prefix: false), "."
    end

    if OS.mac?
      # Enable openmp
      ENV.append_to_cflags "-Xpreprocessor -fopenmp"
      ENV.append "LDFLAGS", "-L#{formula_opt_lib("libomp")} -lomp"
      ENV.append "CPPFLAGS", "-I#{formula_opt_include("libomp")}"
    else
      # Linux build is not thread-safe.
      ENV.deparallelize
    end

    args = %W[
      PYTHON=#{which(python3)}
      --with-python-module-path=#{prefix/Language::Python.site_packages(python3)}
      --with-boost-python=boost_#{python3.delete(".")}
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
      If you want graph drawing, you will need to install additional formulae:
        brew install gtk+3 py3cairo pygobject3 python-matplotlib

      If you want zstd decompression, you can use the bundled Python package, e.g.
        export PYTHONPATH="#{opt_libexec/Language::Python.site_packages(python3)}"
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
    refute_match "drawing will not work", shell_output("#{python3} test.py 2>&1")
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
