class Networkit < Formula
  desc "Performance toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/refs/tags/11.2.tar.gz"
  sha256 "ed762fb2b893425fe05074fa746db58c1e7bef4d96d9921e72d6ae8ca387f995"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7bfe393457656684e4d99dde255af9d08e2fb0398e8af143f649d8d0f13caf6f"
    sha256 cellar: :any, arm64_sequoia: "beda63eb01b52c280720c5c836772bd5a3f32d4f21e8e1a7943fb75b50df979f"
    sha256 cellar: :any, arm64_sonoma:  "5956b4c185583fc4647acad32be3769323eb8d5db4ef49ad9dc1dddd1acd6e83"
    sha256 cellar: :any, sonoma:        "f1facd484f2223890376be420ae5cb588b8720dd7a6ce5fac6ea28b09470b578"
    sha256               arm64_linux:   "b8a4e9fcd03bf9c5b7340aede1d10af2ab37456f63ad0a7b819e3e878d237278"
    sha256               x86_64_linux:  "2dde033c4a4b5963d0f646cdbe87a929fcf1d6795c2c0c2c63c69b73f5fd3e6f"
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
