class Networkit < Formula
  desc "Performance toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/refs/tags/11.0.tar.gz"
  sha256 "3cba54b384db4adfd88c984805647a3b74ed52168b6178cba6dd58f1cbd73120"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "67512bde8a3002943fbce9661f044a4fe2b9f5d32d9eab170842eeb27886553e"
    sha256 cellar: :any,                 arm64_sonoma:  "52caf31178048201b41939aea1b67931197ce1a89ff98e61395a4e8da534b891"
    sha256 cellar: :any,                 arm64_ventura: "cfe6b92239a4fbd03806c6bfe96b21845fad629e9cf8a90c816cd9ecb649ffc9"
    sha256 cellar: :any,                 sonoma:        "9fcaf27378c203f149f19a4c5017102c1962b016f3869ed024bf960c8c4b047f"
    sha256 cellar: :any,                 ventura:       "9e861c9718997e41723b0a6bea6710ad70eebef92000f8488fce3547b193b552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69a25d994bee1c505e3e08a6bd472b5562d08af6066c4512ed9238474f385dee"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "ninja" => :build
  depends_on "python-setuptools" => :build
  depends_on "tlx" => :build

  depends_on "libnetworkit"
  depends_on "numpy"
  depends_on "python@3.13"
  depends_on "scipy"

  on_macos do
    depends_on "libomp"
  end

  def python3
    which("python3.13")
  end

  # Add compat for numpy 2.0
  patch do
    url "https://github.com/networkit/networkit/commit/165503580caac864c7a31558b4c5fee27bcb007e.patch?full_index=1"
    sha256 "67bd2d1fe3ebccb42ccdd1f7cf5aeea40967caa4e9bc96cc69737dc14ffa9654"
  end

  def install
    site_packages = Language::Python.site_packages(python3)

    ENV.prepend_create_path "PYTHONPATH", prefix/site_packages
    ENV.append_path "PYTHONPATH", Formula["cython"].opt_libexec/site_packages

    networkit_site_packages = prefix/site_packages/"networkit"
    extra_rpath = rpath(source: networkit_site_packages, target: Formula["libnetworkit"].opt_lib)
    system python3, "setup.py", "build_ext", "--networkit-external-core",
                                             "--external-tlx=#{Formula["tlx"].opt_prefix}",
                                             "--rpath=#{loader_path};#{extra_rpath}"

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system python3, "-c", <<~EOS
      import networkit as nk
      G = nk.graph.Graph(3)
      G.addEdge(0,1)
      G.addEdge(1,2)
      G.addEdge(2,0)
      assert G.degree(0) == 2
      assert G.degree(1) == 2
      assert G.degree(2) == 2
    EOS
  end
end
