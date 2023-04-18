class Networkit < Formula
  include Language::Python::Virtualenv

  desc "Performance toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/refs/tags/10.1.tar.gz"
  sha256 "35d11422b731f3e3f06ec05615576366be96ce26dd23aa16c8023b97f2fe9039"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6a641907f704a372b44eeb3016fa6f633b48593f8cccdf70245a4fc0a8a0b2ee"
    sha256 cellar: :any,                 arm64_monterey: "e8c3a17455f14617cf8cf83a8cdd4c1eb97cdf92c495e16aaf43bb05d3c84875"
    sha256 cellar: :any,                 arm64_big_sur:  "f551e7a38d6578c04e3024c55f47dfe0c355ba0e23f2b203cf2c7475037bfa16"
    sha256 cellar: :any,                 ventura:        "5df948fc0e43eb9c6a363250a7a5bfefffab863a83d3f1ae7c164d7d6365e836"
    sha256 cellar: :any,                 monterey:       "ff2a389f6edeec2770801b7a1896e4bbe76d9365d9d15ece252a968dd1d8269b"
    sha256 cellar: :any,                 big_sur:        "5fe27b2ffa7ecb1ba75b6562b241a9fb9c79827531a08a91fa04e77aa689095e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9080b4e857eced5cf4f15d10d22a9069612f1fbea8a72e99ea7978f484fd5e92"
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
