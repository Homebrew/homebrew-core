class Networkit < Formula
  include Language::Python::Virtualenv

  desc "Performance toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit.git",
      tag:      "7.1",
      revision: "4c6dcc4367b51005a34221242048609c357ffbd6"
  license "MIT"
  revision 1

  bottle do
    sha256 "23f70cc4fa3dc267391415b12f871ef39e27cca750e2e3a638b9075075ef4314" => :arm64_big_sur
    sha256 "e9e7a572043c181f4aca4c76099b4d1d15e64108c15f5a85f308e9670a23afe4" => :catalina
    sha256 "b89291dd82191c1f0723260297b0b95be0a060380dc820cd4041b00a4a48e149" => :mojave
    sha256 "4c5688263e090b92933eda18a481a6c4de5e30460b1d503148fdc614c0324b2c" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
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
