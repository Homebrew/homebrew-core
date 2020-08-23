class Networkit < Formula
  include Language::Python::Virtualenv

  desc "Performance toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit.git",
      tag:      "7.0",
      revision: "d8e952f1e4d5e2758e4744e7c6ea7429a59c7cdf"
  license "MIT"

  bottle do
    sha256 "6c31d49396ef373700c7c852fb9a0df5793fedb882b8b32fb5149bfc8c4bcffe" => :catalina
    sha256 "53fcb186c2e3b629a6edbe33f9ceff4cb2fefed36f21c721f6273d75e7fb2af2" => :mojave
    sha256 "fe03e0e1716b223d4a0319a36e39c7391477454203fcc3a0a65f5684fce5cf62" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "libnetworkit"
  depends_on "numpy"
  depends_on "python@3.8"
  depends_on "scipy"

  def install
    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    rpath_addons = Formula["libnetworkit"].opt_lib

    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python#{xy}/site-packages/"
    system Formula["python@3.8"].opt_bin/"python3", "setup.py", "build_ext",
          "--networkit-external-core",
           "--rpath=@loader_path;#{rpath_addons}"
    system Formula["python@3.8"].opt_bin/"python3", "setup.py", "install",
           "--single-version-externally-managed",
           "--record=installed.txt",
           "--prefix=#{libexec}"
    site_packages = "lib/python#{xy}/site-packages"
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-networkit.pth").write pth_contents
  end

  test do
    system Formula["python@3.8"].opt_bin/"python3", "-c", <<~EOS
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
