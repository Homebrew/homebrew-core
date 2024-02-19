class GraphTool < Formula
  include Language::Python::Virtualenv

  desc "Efficient network analysis for Python 3"
  homepage "https://graph-tool.skewed.de/"
  url "https://downloads.skewed.de/graph-tool/graph-tool-2.59.tar.bz2"
  sha256 "cde479c0a7254b72f6e795d03b0273b0a7d81611a6a3364ba649c2c85c99acae"
  license "LGPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://downloads.skewed.de/graph-tool/"
    regex(/href=.*?graph-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "ff0c95605ed9a02c48b44ccf428faf8d3619a748b18572dc3b6a9fb9dcea68d6"
    sha256                               arm64_ventura:  "a7219f22ef4158f40933f7912b8a0ad48ca533c3770c158df99b14b1fe1c8a06"
    sha256                               arm64_monterey: "bdff17b1254a14480a828b09d2732643c3e12ae4e11abfebff6709d153917568"
    sha256                               sonoma:         "bb266340fdc1fd0728adeb90aeff3241e0118e54907b0335c249bd4473d23cfc"
    sha256                               ventura:        "17970cc956fd334c366335d4f532a8f54d1f0479ffc387a55ff3d5d6414ee376"
    sha256                               monterey:       "294e8fa876ac401ba644d09a32b9bf80002a85a9c593e3c4907724350c8e97a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1aa7a3df8ea24382ab5e04662b77be08fdb82ef9c75f53c04fa95ea2a8772dac"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
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
  depends_on "pillow"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python-matplotlib"
  depends_on "python-packaging"
  depends_on "python-pyparsing"
  depends_on "python@3.12"
  depends_on "scipy"
  depends_on "six"

  uses_from_macos "expat" => :build

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/5d/91/2162ab4239b3bd6743e8e407bc2442fca0d326e2d77b3f4a88d90ad5a1fa/zstandard-0.22.0.tar.gz"
    sha256 "8226a33c542bcb54cd6bd0a366067b610b41713b64c9abec1bc4533d69f51e70"
  end

  # https://git.skewed.de/count0/graph-tool/-/wikis/Installation-instructions#manual-compilation

  def python3
    "python3.12"
  end

  def install
    # Linux build is not thread-safe.
    ENV.deparallelize unless OS.mac?

    system "autoreconf", "--force", "--install", "--verbose"
    site_packages = Language::Python.site_packages(python3)
    xy = Language::Python.major_minor_version(python3)
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    args = %W[
      PYTHON=#{python3}
      --with-python-module-path=#{prefix/site_packages}
      --with-boost-python=boost_python#{xy.to_s.delete(".")}-mt
      --with-boost-libdir=#{Formula["boost"].opt_lib}
      --with-boost-coroutine=boost_coroutine-mt
    ]
    if OS.mac?
      args << "--with-expat=#{MacOS.sdk_path}/usr" if MacOS.sdk_path_if_needed
      args << "PYTHON_LIBS=-undefined dynamic_lookup"
    end

    system "./configure", *std_configure_args, *args
    system "make", "install"

    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-graph-tool.pth").write pth_contents
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
    system python3, "test.py"
  end
end
