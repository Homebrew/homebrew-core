class GraphTool < Formula
  include Language::Python::Virtualenv

  desc "Efficient network analysis for Python 3"
  homepage "https://graph-tool.skewed.de/"
  url "https://downloads.skewed.de/graph-tool/graph-tool-3.9.tar.bz2"
  sha256 "812ab3575cae13dd6faad96e4d932797a7a71a84480a1eacbb874f2ebafc7c69"
  license "LGPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://downloads.skewed.de/graph-tool/"
    regex(/href=.*?graph-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "f005f71d159c33828d4fa3e434017df5e3bf1e53c852adfdbd8ecdf096447748"
    sha256 arm64_tahoe:       "696b68b78a4ad4a66b6b723e9be9d4cdae41335517d67957e01395c585737759"
    sha256 arm64_sequoia:     "6bd9993eb0f9dd84bb5d913cc9b75a73080741b0c8bf80bb21d284858d5689ed"
    sha256 arm64_linux:       "d5e5f094002d172ee1cfd8b620b71729304e792635d39118490a900ee1ffc241"
    sha256 x86_64_linux:      "0d6e3f45dc72551d76afd7de96139a2d7be22fa927ee53254616be7434ae2fb3"
  end

  depends_on "cgal" => :build
  depends_on "pkgconf" => :build
  depends_on "py3cairo" => [:build, :test]
  depends_on "python-setuptools" => :build # for zstandard

  # only test optional graph drawing feature to reduce required runtime dependencies
  depends_on "pygobject3" => :test
  depends_on "python-matplotlib" => :test

  depends_on "boost"
  depends_on "boost-python3"
  depends_on "cairomm"
  depends_on "gmp"
  depends_on "numpy" => :no_linkage
  depends_on "python@3.15"
  depends_on "scipy" => :no_linkage
  depends_on "zstd"

  uses_from_macos "expat", since: :sequoia

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 2100
    depends_on "cairo"
    depends_on "libomp"
    depends_on "libsigc++"
  end

  on_linux do
    depends_on "gcc"
  end

  fails_with :clang do
    build 2100
    cause "needs C++23"
  end

  fails_with :gcc do
    version "14"
    cause "needs C++23"
  end

  pypi_packages package_name:   "",
                extra_packages: "zstandard"

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/fd/aa/3e0508d5a5dd96529cdc5a97011299056e14c6505b678fd58938792794b1/zstandard-0.25.0.tar.gz"
    sha256 "7713e1179d162cf5c7906da876ec2ccb9c3a9dcbdffef0cc7f70c3667a205f0b"
  end

  def install
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
    end

    # Linux often hits OOM as runners lack swap memory while macOS may thrash
    # due to some compilation jobs exceeding 20 GB of memory.
    ENV.deparallelize

    # From https://git.skewed.de/count0/graph-tool/-/blob/release-3.7/configure.ac#L67-69
    # > Enforce -O3. It makes a substantial difference, e.g. 12x speed improvement over -O2 in benchmarks.
    ENV.O3

    args = %W[
      PYTHON=#{python3}
      --with-python-module-path=#{prefix/Language::Python.site_packages(python3)}
      --with-boost-python=boost_#{python3.basename.to_s.delete(".")}
      --with-boost-libdir=#{formula_opt_lib("boost")}
      --with-boost-coroutine=boost_coroutine
      --disable-silent-rules
    ]
    args << "PYTHON_LIBS=-undefined dynamic_lookup" if OS.mac?
    # LTO moves memory contraints from compilation to linking which helps with build time on Linux
    args << "MOD_CXXFLAGS=-flto" if OS.linux?

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
      import sys
      # Importing Gtk initialises GDK, which aborts without a window server, so skip GTK+ drawing
      sys.modules["gi.repository.Gtk"] = None
      import graph_tool.all as gt
      g = gt.Graph()
      v1 = g.add_vertex()
      v2 = g.add_vertex()
      e = g.add_edge(v1, v2)
      assert g.num_edges() == 1
      assert g.num_vertices() == 2
    PYTHON
    refute_match(/Error importing (cairo|matplotlib)/, shell_output("#{python3} test.py 2>&1"))
  end
end
