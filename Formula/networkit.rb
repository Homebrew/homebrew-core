class Networkit < Formula
  include Language::Python::Virtualenv

  desc "Performance toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/8.0.tar.gz"
  sha256 "cdf9571043edbe76c447622ed33efe9cba2880f887ca231d98f6d3c22027e20e"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "6bcc6f2a916a88aecde8ba207f9529e85f4aa5c0824103cd174edd8305829853"
    sha256 big_sur:       "1d61dc3b796983a9917d3432c81f71970124b1b92223571f8e71e5d93bfcf3a3"
    sha256 catalina:      "9993759bccd6358ac11a8155f38f00c567216fde5f6b9bf7bf7540c16b3ade4d"
    sha256 mojave:        "91d651e6ddc12737aa0c54bc70426a2156247fe24360bb4c4de1d548e5838224"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "tlx" => :build

  depends_on "libnetworkit"
  depends_on "numpy"
  depends_on "python@3.9"
  depends_on "scipy"

  # setup.py: add --external-tlx option
  # https://github.com/networkit/networkit/pull/666
  patch do
    url "https://github.com/networkit/networkit/commit/dbe93306402e6ffee78bf45df5efc9cf2ac991a7.patch?full_index=1"
    sha256 "7b50df48972f5490ede25e101d04e7ec4b1c4f8ededfdaee94c17fedf917d572"
  end

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
