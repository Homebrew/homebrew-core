class Networkit < Formula
  include Language::Python::Virtualenv

  desc "Performance toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/9.1.1.tar.gz"
  sha256 "0376b3b7b8ba1fefb46549c7dd2cf979237a24708293715b1da92b4da272a742"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_monterey: "34d3a02ef514cf53e77cf00082e889ac93b0ec532f9a1fcea6c6ec08ba426761"
    sha256 cellar: :any, arm64_big_sur:  "a41320e53a56631eba9d16927a2d8bc35880db0702e25adf14bfc377ef2f5f75"
    sha256 cellar: :any, monterey:       "b468e08ba6ab0065b94003554360602c63e58096f0000e1d0ec7f15cb64dfbdc"
    sha256 cellar: :any, big_sur:        "8c8341f80a04288cff1f1755a0a87b3d285cc031bfeeae6de1802d2ff8c23822"
    sha256 cellar: :any, catalina:       "6022341e3e95e3f8e11516e6118ad6fcc5f233aa5f96d030684ade3dad268e5f"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
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
