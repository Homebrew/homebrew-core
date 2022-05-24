class Networkit < Formula
  include Language::Python::Virtualenv

  desc "Performance toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/9.1.1.tar.gz"
  sha256 "0376b3b7b8ba1fefb46549c7dd2cf979237a24708293715b1da92b4da272a742"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "dba17aec211b9a8def53232466c251ac398e38a3d1ad3c5d76b0bf11ca144c55"
    sha256 cellar: :any, arm64_big_sur:  "d158fcf26c6611109a72ff60fc73a8c3546efb824f2ccc6cde0058c111d91952"
    sha256 cellar: :any, monterey:       "f443a8636f1579826d9793613578d06adef3165773ee1353f32774081f253021"
    sha256 cellar: :any, big_sur:        "ea766a3afd870e69d1860c4e093ac5cb431a495d9b304d3ba21c032717635213"
    sha256 cellar: :any, catalina:       "456b7dbc97239bb9f3a9aa4588def29fb16a0c1f021017ad55b61ebcb60a9d72"
  end

  depends_on "cmake" => :build
  depends_on "libcython" => :build
  depends_on "ninja" => :build
  depends_on "tlx" => :build

  depends_on "libnetworkit"
  depends_on "numpy"
  depends_on "python@3.9"
  depends_on "scipy"

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    rpath_addons = Formula["libnetworkit"].opt_lib

    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python#{xy}/site-packages/"
    ENV.append_path "PYTHONPATH", Formula["libcython"].opt_libexec/"lib/python#{xy}/site-packages"
    system Formula["python@3.9"].opt_bin/"python3", "setup.py", "build_ext",
          "--networkit-external-core",
          "--external-tlx=#{Formula["tlx"].opt_prefix}",
          "--rpath=@loader_path;#{rpath_addons}"
    system Formula["python@3.9"].opt_bin/"python3", "setup.py", "install",
           "--single-version-externally-managed",
           "--record=installed.txt",
           "--prefix=#{libexec}"
    site_packages = "lib/python#{xy}/site-packages"
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-networkit.pth").write pth_contents
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", <<~EOS
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
