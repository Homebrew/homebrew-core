class Networkit < Formula
  include Language::Python::Virtualenv

  desc "Performance toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/refs/tags/10.1.tar.gz"
  sha256 "35d11422b731f3e3f06ec05615576366be96ce26dd23aa16c8023b97f2fe9039"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "728f021d0fbf6fe3237db7ba75b3cc637fe38b0db5d4bcf1f8c88f4fc0461dfd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23470b1cb591899116c01c966304451024bcea4ed7ba8f13ae4bbe1986ec00c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcb9af0f8f137c35009fe9ac19c25c165adc7e123653a221c00b6f780cb4ac7a"
    sha256 cellar: :any_skip_relocation, ventura:        "7d3e07e85b55cda32842c7eae2d7752a59618a3fbcb2fe11231bf9c392cc641b"
    sha256 cellar: :any_skip_relocation, monterey:       "b6ce1a8d4694d1e3434fc23e0a99d605bd777f151b2e7c8da56b5312ce3e7130"
    sha256 cellar: :any_skip_relocation, big_sur:        "45397cfad06aeb74e92fd34c773772d5fa14ecf9aa32d23b79643e31e1ae33a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c288ca970f924b07fb6619e453ebb54f013b4665f5f6d90b797af2026e134161"
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
    which("python3.11")
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

    system python3, "-m", "pip", "install", *std_pip_args, "."
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
