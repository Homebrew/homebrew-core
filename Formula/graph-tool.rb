class GraphTool < Formula
  # Include Virtualenv for venv setup - required for installing matplotlib into venv
  include Language::Python::Virtualenv

  desc "Efficient network analysis for python 3"
  homepage "https://graph-tool.skewed.de/"
  url "https://downloads.skewed.de/graph-tool/graph-tool-2.26.tar.bz2"
  sha256 "df6273dc5ef327a0eaf1ef1c46751fce4c0b7573880944e544287b85a068f770"

  head do
    url "https://git.skewed.de/count0/graph-tool.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  bottle :disable, "needs to be rebuilt with latest boost"
  # add implicit 'with'
  option "with-openmp", "Enable OpenMP multithreading"
  # Yosemite build fails with Boost >=1.64.0 due to thread-local storage error
  depends_on :macos => :el_capitan
  depends_on "python" => :recommended
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "cgal"
  depends_on "google-sparsehash" => :recommended
  depends_on "numpy"
  depends_on "scipy"
  # explicitly requiring gtk+3 and py3cairo here because audit doesn't permit:
  # i.e. depends_on "librsvg" => "with-gtk+3" (doesn't do anything overly meaningful in the librsvg formula)
  # i.e. depends_on "pygobject3" => "with-python"
  depends_on "gtk+3"
  depends_on "librsvg"
  depends_on "cairomm"
  depends_on "py3cairo"
  # pygobject3 pending rename to pygobject per https://github.com/Homebrew/homebrew-core/pull/18711
  depends_on "pygobject3" => "with-python"
  fails_with :gcc => "4.8" do
    cause "We need GCC 5.0 or above for sufficient c++14 support"
  end
  fails_with :gcc => "4.9" do
    cause "We need GCC 5.0 or above for sufficient c++14 support"
  end
  depends_on "gcc" if build.with? "openmp"

  # matplotlib is no longer available since the deprecation of homebrew-science
  # use resources instead - following resource stanzas generated with homebrew-pypi-poet
  resource "Cycler" do
    url "https://files.pythonhosted.org/packages/c2/4b/137dea450d6e1e3d474e1d873cd1d4f7d3beed7e0dc973b06e8e10d32488/cycler-0.10.0.tar.gz"
    sha256 "cd7b2d1018258d7247a71425e9f26463dfb444d411c39569972f4ce586b0c9d8"
  end
  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/50/27/57ab73d1b094540dec1a01d2207613248d8106f3c3f40e8d86f02eb8d18b/matplotlib-2.1.1.tar.gz"
    sha256 "659f5e1aa0e0f01488c61eff47560c43b8be511c6a29293d7f3896ae17bd8b23"
  end
  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz"
    sha256 "0832bcf47acd283788593e7a0f542407bd9550a55a8a8435214a1960e04bcb04"
  end
  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/54/bb/f1db86504f7a49e1d9b9301531181b00a1c7325dc85a29160ee3eaa73a54/python-dateutil-2.6.1.tar.gz"
    sha256 "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca"
  end
  resource "pytz" do
    url "https://files.pythonhosted.org/packages/60/88/d3152c234da4b2a1f7a989f89609ea488225eaea015bc16fbde2b3fdfefa/pytz-2017.3.zip"
    sha256 "fae4cffc040921b8a2d60c6cf0b5d662c1190fe54d718271db4eb17d44a185b7"
  end
  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    system "./autogen.sh" if build.head?
    config_args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    # fix issue with boost + gcc with C++11/C++14
    ENV.append "CXXFLAGS", "-fext-numeric-literals" unless ENV.compiler == :clang
    config_args << "--disable-sparsehash" if build.without? "google-sparsehash"
    config_args << "--enable-openmp" if build.with? "openmp"
    Language::Python.each_python(build) do |python, version|
      next unless python == "python3"
      puts "Installing graph-tool for Python 3"
      config_args_x = ["PYTHON=#{python}"]
      config_args_x << "PYTHON_LDFLAGS=-undefined dynamic_lookup"
      config_args_x << "PYTHON_LIBS=-undefined dynamic_lookup"
      config_args_x << "PYTHON_EXTRA_LIBS=-undefined dynamic_lookup"
      config_args_x << "--with-python-module-path=#{lib}/python#{version}/site-packages"
      # check that configure is set to python3
      inreplace "configure", "libboost_python", "libboost_python3"
      inreplace "configure", "ax_python_lib=boost_python", "ax_python_lib=boost_python3"
      venv3 = virtualenv_create(libexec, "python3")
      # auto installing resources with virtualenv_install_with_resources creates issues because:
      # A) It tries to install all resources regardless of environment, and
      # B) It looks for a setup.py for graph-tool which returns an error
      # Therefore, install and link resources individually with pip_install_and_link instead
      %w[Cycler matplotlib pyparsing python-dateutil pytz six].each do |r|
        venv3.pip_install_and_link resource(r)
      end
      mkdir "build-#{python}-#{version}" do
        system "../configure", *(config_args + config_args_x)
        system "make", "install"
      end
      site_packages = "lib/python#{version}/site-packages"
      pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
      (prefix/site_packages/"homebrew-graph-tool.pth").write pth_contents
    end
  end

  test do
    Pathname("test.py").write <<~EOS
      import graph_tool.all as gt
      g = gt.Graph()
      v1 = g.add_vertex()
      v2 = g.add_vertex()
      e = g.add_edge(v1, v2)
      assert g.num_edges() == 1
      assert g.num_vertices() == 2
    EOS
    Language::Python.each_python(build) { |python, _| system python, "test.py" }
  end
end
