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
    rebuild 1
    sha256                               arm64_sonoma:   "9133e6bfcf83da1e6e01dc7852e66015feff519d0c8c37049bdef94b07f0fd4d"
    sha256                               arm64_ventura:  "13e04e5e92733eb29cefcec488ed50d0d364fac3988344d9f5c3bce2f9f8836e"
    sha256                               arm64_monterey: "5a6383c3a6de34cad20d58090faaa92c096cecfabb383dcdc7147d95640179f7"
    sha256                               sonoma:         "fc7a7ef28bee069a781ac012d5c55f72d9e358b57acd32858b34c83076807f6a"
    sha256                               ventura:        "7811a58ab0817b8dda9ccae86caeb5c97c88859c49fd5838ccc941913ef19a4f"
    sha256                               monterey:       "c8cf54a6348b9fd2b1c8ae2a73346d0bfbb519dea9644b874e5b1461b80f6f7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b1839300e7cf5ba5db4b235b4bb93d46918fa9980dd3114d656c4ccdf86c7db"
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
  depends_on "python@3.12"
  depends_on "scipy"

  uses_from_macos "expat" => :build

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/37/fe/65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44b/pyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

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
