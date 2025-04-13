class Networkit < Formula
  desc "Performance toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/refs/tags/11.1.tar.gz"
  sha256 "c8db0430f6d7503eaf1e59fbf181374dc9eaa70f572c56d2efa75dd19a3548a9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "472a50deee447e0e9e0bf740f00e4b3b249797e3d582a78a343651dddbf761aa"
    sha256 cellar: :any,                 arm64_sonoma:  "9818772678ceab5b2aa821024375443b8216889f4a70f66793610c3ed0ecb4fc"
    sha256 cellar: :any,                 arm64_ventura: "2076c895a92bb11a20e247c107f6a190ac1a878cb944601f5de466ac55f49c83"
    sha256 cellar: :any,                 sonoma:        "7cdd6d09da9f9d9c8fcaee9bbf82c8e7bf8a3a1ee58f21f25e4505a63939df88"
    sha256 cellar: :any,                 ventura:       "7eafc01948f29effad09481dacf7ade9abee082ca9b1414c2244f0571d2f62bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e72b1db4cd8a202ba384791c2aa5a67de8bc4dbf5eba902e9b21a6403ad3fadc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d745c520d2e0211881030a888704232e07d48dc6e81fa4079584b886a3f65263"
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
