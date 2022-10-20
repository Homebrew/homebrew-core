class GraphTool < Formula
  include Language::Python::Virtualenv

  desc "Efficient network analysis for Python 3"
  homepage "https://graph-tool.skewed.de/"
  url "https://downloads.skewed.de/graph-tool/graph-tool-2.45.tar.bz2"
  sha256 "f92da7accfda02b29791efe4f0b3ed93329f27232af4d3afc07c92421ec68668"
  license "LGPL-3.0-or-later"
  revision 3

  livecheck do
    url "https://downloads.skewed.de/graph-tool/"
    regex(/href=.*?graph-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_monterey: "cefa9e4aa514f88449e0eac1443aec41789a1837143d8bac6e4c285dce2893f7"
    sha256                               arm64_big_sur:  "f69ab24a3b744e48b3c293591794cea45c9b7c22f19db34736b19c5985639f4b"
    sha256                               monterey:       "eb3b025abd1640bf31dd775d843a91928d2f44c83c52c4508519b1ab14d12bc8"
    sha256                               big_sur:        "ba031e95b34ab31013941727a83fe6ce07007798e91fb9c8e7e5647d831e2c78"
    sha256                               catalina:       "4484f4162621e6a4069edb80c05973c9f6dbc6423d5ef9ed5f421b4dabc01af3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05aa60765b805c9b0f8f7b1e35dfe0829e1f5c94b4a82ba53e5870393cd21b46"
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
  depends_on "python@3.10"
  depends_on "scipy"
  depends_on "six"

  uses_from_macos "expat" => :build

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

  def python3
    deps.map(&:to_formula)
        .find { |f| f.name.match?(/^python@\d\.\d+$/) }
        .opt_libexec/"bin/python"
  end

  def install
    # Linux build is not thread-safe.
    ENV.deparallelize unless OS.mac?

    system "autoreconf", "--force", "--install", "--verbose"
    site_packages = Language::Python.site_packages(python3)
    xy = Language::Python.major_minor_version(python3)
    venv = virtualenv_create(libexec, python3)

    resources.each do |r|
      venv.pip_install_and_link r
    end

    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "PYTHON=python3",
      "--with-python-module-path=#{prefix/site_packages}",
      "--with-boost-python=boost_python#{xy.to_s.delete(".")}-mt",
      "--with-boost-libdir=#{Formula["boost"].opt_lib}",
      "--with-boost-coroutine=boost_coroutine-mt",
    ]
    args << "--with-expat=#{MacOS.sdk_path}/usr" if MacOS.sdk_path_if_needed
    args << "PYTHON_LIBS=-undefined dynamic_lookup" if OS.mac?

    system "./configure", *args
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
