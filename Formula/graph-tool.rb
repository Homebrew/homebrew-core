class GraphTool < Formula
  include Language::Python::Virtualenv

  desc "Efficient network analysis for Python 3"
  homepage "https://graph-tool.skewed.de/"
  url "https://downloads.skewed.de/graph-tool/graph-tool-2.45.tar.bz2"
  sha256 "f92da7accfda02b29791efe4f0b3ed93329f27232af4d3afc07c92421ec68668"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://downloads.skewed.de/graph-tool/"
    regex(/href=.*?graph-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_monterey: "62a2545e6296c558c337f6207d11c3f156bdce0d4c0e8bbea6379f67fc24948f"
    sha256                               arm64_big_sur:  "34395ee0ea68f11b588e87eb521664e42c883dffd06f7e48594b48c868675a6b"
    sha256                               monterey:       "f4db1813477f61b95735bb738ccef6a2a686f9ea2d837b80e406ba8311904959"
    sha256                               big_sur:        "1ec7e4f24cd3215a8ed5a87f8fc6cc98c2a8e673cd00250162c5f053bfa48391"
    sha256                               catalina:       "20a90c4bf61f3ce2e346ae4279b717efaa891872ebb7815c004916dcee15d399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "283b51758494ed6dc084410d97ced1b46022f74f378ffbac7872ab34a3d28e82"
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
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.9"
  depends_on "scipy"
  depends_on "six"

  uses_from_macos "expat" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  resource "Cycler" do
    url "https://files.pythonhosted.org/packages/c2/4b/137dea450d6e1e3d474e1d873cd1d4f7d3beed7e0dc973b06e8e10d32488/cycler-0.10.0.tar.gz"
    sha256 "cd7b2d1018258d7247a71425e9f26463dfb444d411c39569972f4ce586b0c9d8"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/90/55/399ab9f2e171047d28933ae4b686d9382d17e6c09a01bead4a6f6b5038f4/kiwisolver-1.3.1.tar.gz"
    sha256 "950a199911a8d94683a6b10321f9345d5a3a8433ec58b217ace979e18f16e248"
  end

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/60/d3/286925802edaeb0b8834425ad97c9564ff679eb4208a184533969aa5fc29/matplotlib-3.4.2.tar.gz"
    sha256 "d8d994cefdff9aaba45166eb3de4f5211adb4accac85cbf97137e98f26ea0219"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/b0/61/eddc6eb2c682ea6fd97a7e1018a6294be80dba08fa28e7a3570148b4612d/pytz-2021.1.tar.gz"
    sha256 "83a4a90894bf38e243cf052c8b58f381bfe9a7a483f6a9cab140bc7f702ac4da"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/b4/79/7b192e51a2952dee3a3c9dbd9208a9838d8d497745a18a5528e2dbfb465e/zstandard-0.15.2.tar.gz"
    sha256 "52de08355fd5cfb3ef4533891092bb96229d43c2069703d4aff04fdbedf9c92f"
  end

  def install
    # Linux build is not thread-safe.
    ENV.deparallelize unless OS.mac?

    system "autoreconf", "-fiv"
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    venv = virtualenv_create(libexec, Formula["python@3.9"].opt_bin/"python3")

    resources.each do |r|
      venv.pip_install_and_link r
    end

    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "PYTHON=python3",
      "--with-python-module-path=#{lib}/python#{xy}/site-packages",
      "--with-boost-python=boost_python#{xy.to_s.delete(".")}-mt",
      "--with-boost-libdir=#{HOMEBREW_PREFIX}/opt/boost/lib",
      "--with-boost-coroutine=boost_coroutine-mt",
    ]
    args << "--with-expat=#{MacOS.sdk_path}/usr" if MacOS.sdk_path_if_needed
    args << "PYTHON_LIBS=-undefined dynamic_lookup" if OS.mac?

    system "./configure", *args
    system "make", "install"

    site_packages = "lib/python#{xy}/site-packages"
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
    system Formula["python@3.9"].opt_bin/"python3", "test.py"
  end
end
