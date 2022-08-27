class Networkit < Formula
  include Language::Python::Virtualenv

  desc "Performance toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/10.0.tar.gz"
  sha256 "77187a96dea59e5ba1f60de7ed63d45672671310f0b844a1361557762c2063f3"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "28571a0866090c5bb5f37e4cfa50011fd3937e9eaae1288861420529c1b93a85"
    sha256 cellar: :any, arm64_big_sur:  "8d4529866191018e40886f83d6916af78181a402999632afd7738c80751105ed"
    sha256 cellar: :any, monterey:       "68d0dead144ba2a5699edfe832168a0031938cf583132120df246f9affbe3047"
    sha256 cellar: :any, big_sur:        "961285cea4f57c3873d36009b0a97c5ababb27f354e19411b9bf2a9f0102f1f2"
    sha256 cellar: :any, catalina:       "13a02f00004e4718ccbb5f5bb157c8e6557865758ca6e73bda02ab080fe9c1f6"
  end

  depends_on "cmake" => :build
  depends_on "libcython" => :build
  depends_on "ninja" => :build
  depends_on "tlx" => :build

  depends_on "libnetworkit"
  depends_on "numpy"
  depends_on "python@3.10"
  depends_on "scipy"

  def python3
    which("python3.10")
  end

  def install
    site_packages = Language::Python.site_packages(python3)

    ENV.prepend_create_path "PYTHONPATH", prefix/site_packages
    ENV.append_path "PYTHONPATH", Formula["libcython"].opt_libexec/site_packages

    networkit_site_packages = prefix/site_packages/"networkit"
    extra_rpath = rpath(source: networkit_site_packages, target: Formula["libnetworkit"].opt_lib)
    system python3, "setup.py", "build_ext", "--networkit-external-core",
                                             "--external-tlx=#{Formula["tlx"].opt_prefix}",
                                             "--rpath=#{loader_path};#{extra_rpath}"

    system python3, *Language::Python.setup_install_args(prefix, python3)
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
