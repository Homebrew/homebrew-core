class Networkit < Formula
  desc "Performance toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/refs/tags/11.0.tar.gz"
  sha256 "3cba54b384db4adfd88c984805647a3b74ed52168b6178cba6dd58f1cbd73120"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "aeca1389873b623451264b1fa1d44d523c63cb9ea2728c64e312b7baa91eb24a"
    sha256 cellar: :any,                 arm64_ventura:  "c4399d2cadbc56465ab7d3b6381eb2102f7900196d1afcc9c26fde900c31e4d2"
    sha256 cellar: :any,                 arm64_monterey: "e73e3ffd843c1f2174c0bbefd721ba0309cb41d9783866aeaa8fc9c512822efb"
    sha256 cellar: :any,                 sonoma:         "3aaf130e9d503254b0aa715c8fa879edb13ce048a7ac5a34b8e7d0ac6bf6303a"
    sha256 cellar: :any,                 ventura:        "1f45434288fe627d17555645be06405a2d1a62c36404bf466b89c0f2227048de"
    sha256 cellar: :any,                 monterey:       "02e26531757bb9412e6e3ec9f24468fffef797377de1a955e484393b1a2707ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c53c33bf47a6ce53d4181b787fa233096a406ec0b3de7f13d24d8d987f22f36c"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "ninja" => :build
  depends_on "python-setuptools" => :build
  depends_on "tlx" => :build

  depends_on "libnetworkit"
  depends_on "numpy"
  depends_on "python@3.12"
  depends_on "scipy"

  def python3
    which("python3.12")
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
