class Networkit < Formula
  desc "Performance toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/refs/tags/11.0.tar.gz"
  sha256 "3cba54b384db4adfd88c984805647a3b74ed52168b6178cba6dd58f1cbd73120"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "696603d46742a9911d64b7d7413f8b69be5d5c0454896f793f1d59b4dff024fe"
    sha256 cellar: :any,                 arm64_ventura:  "e131660675f6a8b038384ea93d4f0d0b218a7015c5911668b9a5b9e197938126"
    sha256 cellar: :any,                 arm64_monterey: "bf198f04659bdf0b8a3403a73b69b79c53b43bbc2148dc26fe73bc43433906bc"
    sha256 cellar: :any,                 sonoma:         "926fee5a9850b67c9d1c5e6c93136c0cc26218727071293e38e4e2c480c2c42c"
    sha256 cellar: :any,                 ventura:        "88db41a27b63fdf177e1cec08fdba52407a7629b8492f40b8efcc77534569dce"
    sha256 cellar: :any,                 monterey:       "c5daee28c42b0cd1651dbf1f433ff07bd064132d45c6a4788b13d306d08c924c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bcf04f8eb69bf0c822e95750b686b28131f3fb786b71efd66b3b657d4daf82b"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "ninja" => :build
  depends_on "python-setuptools" => :build
  depends_on "tlx" => :build

  depends_on "libnetworkit"
  depends_on "numpy"
  depends_on "python@3.12"
  depends_on "scipy"

  def python3
    which("python3.12")
  end

  def install
    site_packages = Language::Python.site_packages(python3)

    ENV.prepend_create_path "PYTHONPATH", prefix/site_packages
    ENV.append_path "PYTHONPATH", Formula["cython"].opt_libexec/site_packages

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
