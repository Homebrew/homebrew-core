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

  depends_on "cgal" => :build
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
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 2100
    depends_on "cairo"
    depends_on "libomp"
    depends_on "libsigc++"
  end

  on_linux do
    depends_on "lld" => :build
    depends_on "gcc"
  end

  fails_with :clang do
    build 2100
    cause "needs C++23 and clang 2100 segfaults"
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

  def python3 = "python3.14"

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

    # Prevent build script from adding -g even though we set --disable-debug
    ENV["ac_cv_prog_cc_g"] = ENV["ac_cv_prog_cxx_g"] = "no"

    if OS.mac?
      # Enable openmp
      ENV.append_to_cflags "-Xpreprocessor -fopenmp"
      ENV.append "LDFLAGS", "-L#{formula_opt_lib("libomp")} -lomp"
      ENV.append "CPPFLAGS", "-I#{formula_opt_include("libomp")}"
    else
      ENV.append "LDFLAGS", "-fuse-ld=lld"
      # Linux build is not thread-safe
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
    args << "MOD_CXXFLAGS=-flto" if OS.linux?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      If you want graph drawing, you will need to install additional formulae:
        brew install gtk+3 py3cairo pygobject3 python-matplotlib

      If you want zstd decompression, you can use the bundled Python package:
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
