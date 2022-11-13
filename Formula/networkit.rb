class Networkit < Formula
  include Language::Python::Virtualenv

  desc "Performance toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/10.0.tar.gz"
  sha256 "77187a96dea59e5ba1f60de7ed63d45672671310f0b844a1361557762c2063f3"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "225043994ead9033a8edcdcab33b4b2cd8c911058260432712916f528ddd7d3b"
    sha256 cellar: :any,                 arm64_monterey: "b3b2832093a52d3d961fe42465e054ed671fe42dd5ed61e8bd60824e726c8ef5"
    sha256 cellar: :any,                 arm64_big_sur:  "e9e5c140bfb05a6332828086675d8e4bcf068c2c04029ee3d0cc259358c61f23"
    sha256 cellar: :any,                 monterey:       "481afe37e6d16ced50eae8d67ad9740eaba8f696eef74d14af6fee662b11f4ee"
    sha256 cellar: :any,                 big_sur:        "216f7679271686d87637ab1ffbba1b785af560e0b5938da6095891d6d79589f0"
    sha256 cellar: :any,                 catalina:       "3a4d7a959f666b9dfdfa2df033f208de73feb1b08c4f70b72c54ce925760c569"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef01d0f3dc7aa13b1953783ebabae54a1913e0687212cc8e3e96d59f83d89787"
  end

  depends_on "cmake" => :build
  depends_on "libcython" => :build
  depends_on "ninja" => :build
  depends_on "tlx" => :build

  depends_on "libnetworkit"
  depends_on "numpy"
  depends_on "python@3.11"
  depends_on "scipy"

  def python3
    "python3.11"
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
