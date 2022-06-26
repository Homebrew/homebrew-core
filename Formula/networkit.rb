class Networkit < Formula
  include Language::Python::Virtualenv

  desc "Performance toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/10.0.tar.gz"
  sha256 "77187a96dea59e5ba1f60de7ed63d45672671310f0b844a1361557762c2063f3"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_monterey: "b3709535d7981e04a3cd541ed56c2cdf44f7c2dfad82089add38847b1ec86f13"
    sha256 cellar: :any, arm64_big_sur:  "f77a61aafe5956ec50958d41bc7460f8454752dc628dfbbb56ec13ce90146409"
    sha256 cellar: :any, monterey:       "e7f751d0092c78fb44356e0bdd37ea004f34a1a4c7c699ffe789bf0f6b71a403"
    sha256 cellar: :any, big_sur:        "6477dc3b577c6018f366d50ffc5414cd01bbf5d7c7de7a90e49b0e65b30b0cc8"
    sha256 cellar: :any, catalina:       "1bf51a6b071e90a81a5cb8e19d83c4afcf0cb9e59b61185af411161888f7309b"
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
