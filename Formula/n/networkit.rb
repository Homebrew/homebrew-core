class Networkit < Formula
  desc "Performance toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/refs/tags/11.2.1.tar.gz"
  sha256 "969718847465937086728a884b5f143d7f36cfd3f6cdc04ef9ae4f64ba61b60c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ced2920bc1e6701e30cca2d8fc70cf0f9b785cb5fdced49dcaae63ddb2f77d9b"
    sha256 cellar: :any, arm64_sequoia: "04f4977d13c5198b836327852a765cd9e9a8d213817f859cbc51b66a7cd324ca"
    sha256 cellar: :any, arm64_sonoma:  "3dc11cc11c07c71c6d19a9990ecbaa90f0482a0c7d6ef2947ceb3b2550053018"
    sha256 cellar: :any, sonoma:        "84202ae39b325a754d091cb55f9ea530fd378fc9bf81f3aea896b49f3cf8bcd1"
    sha256               arm64_linux:   "b0a4297e282a3eece612c67f3ef520ef56df2687e060588bc8fea3d13cec2b36"
    sha256               x86_64_linux:  "f3490cbbda12ffaeff0028a1353d8763c526d8dd430b01512f4c908cb8619905"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "ninja" => :build
  depends_on "python-setuptools" => :build
  depends_on "tlx" => :build

  depends_on "libnetworkit"
  depends_on "numpy"
  depends_on "python@3.14"
  depends_on "scipy"

  on_macos do
    depends_on "libomp"
  end

  def python3
    which("python3.14")
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
    system python3, "-c", <<~PYTHON
      import networkit as nk
      G = nk.graph.Graph(3)
      G.addEdge(0,1)
      G.addEdge(1,2)
      G.addEdge(2,0)
      assert G.degree(0) == 2
      assert G.degree(1) == 2
      assert G.degree(2) == 2
    PYTHON
  end
end
