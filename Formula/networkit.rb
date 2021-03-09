class Networkit < Formula
  include Language::Python::Virtualenv

  desc "Performance toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/8.1.tar.gz"
  sha256 "0a22eb839606b9fabfa68c7add12c4de5eee735c6f8bb34420e5916ce5d7f829"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "f31b0dd888f0f6f8b9a5150f6c77e43e51b1c636e82c55c035b1a2896c9843c0"
    sha256 big_sur:       "ae370fdd0974d13ff6a572d2041e651738ae05da78f357c52ca32507a20cf137"
    sha256 catalina:      "da73389019eb5285306e33e95e7bf3c223bef8a6037630ec11fe0bf7d3bc8f81"
    sha256 mojave:        "a8fad9747011befa4f6995d09cfd21355649d57a99a969b63b8b15d1189336d4"
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
