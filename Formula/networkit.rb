class Networkit < Formula
  include Language::Python::Virtualenv

  desc "Performance toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/9.0.tar.gz"
  sha256 "c574473bc7d86934f0f4b3049c0eeb9c4444cfa873e5fecda194ee5b1930f82c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6830b5a174f2faa428c162a31cbac98867ac91847e20c44fc0b942a054dc172c"
    sha256 cellar: :any, monterey:      "ca1e55e40092e27cd535d26c8f2a87c332fa8702f6c84272bedf7fe93643c78f"
    sha256 cellar: :any, big_sur:       "734ae79b47e434f3e3d1e8ddaf2ae0edef1b48b4e4a6bd2f82ba201abdb51cbe"
    sha256 cellar: :any, catalina:      "05e4c80f053b211a5fc3bb905c93a96dfd488c2f078c926de6b6459aeb7409e4"
    sha256 cellar: :any, mojave:        "f39d81732bf9dc5093bb3537b7f1436a23b02956fa5856fd4b46a8ac7de67a93"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "tlx" => :build

  depends_on "libnetworkit"
  depends_on "numpy"
  depends_on "python@3.9"
  depends_on "scipy"

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    rpath_addons = Formula["libnetworkit"].opt_lib

    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python#{xy}/site-packages/"
    ENV.append_path "PYTHONPATH", Formula["cython"].opt_libexec/"lib/python#{xy}/site-packages"
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
