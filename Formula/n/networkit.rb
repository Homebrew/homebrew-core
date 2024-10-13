class Networkit < Formula
  desc "Performance toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/refs/tags/11.0.tar.gz"
  sha256 "3cba54b384db4adfd88c984805647a3b74ed52168b6178cba6dd58f1cbd73120"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d1ee1f4207bd871fe8ff61585cdef1b3e4c60c4fb81cc83d9d7735a78aa477fa"
    sha256 cellar: :any,                 arm64_sonoma:   "70c1c15cd23f64eebc96c298bd0f14568713859c88a4a0d3c4e3750162ff16cc"
    sha256 cellar: :any,                 arm64_ventura:  "440bf3494d183b0fedd042d315715cd846309e1e4376989b67b61d1ac3a96737"
    sha256 cellar: :any,                 arm64_monterey: "3d760b478449d4868f3b1f2512ae7de755143bdedb18e2fa7049c9e81c328fea"
    sha256 cellar: :any,                 sonoma:         "07ec12c1a32223d664983d98c5631b34e078c50f0d0b9a840c338625d754dd1e"
    sha256 cellar: :any,                 ventura:        "1e283912462220c5ecc227563a3a47619d3f8861e1cb8c63a53e4e6f2b17d625"
    sha256 cellar: :any,                 monterey:       "4465ee60841f24f90c56c77c49cbbc458aa91d4119950209f3c889991f8c46f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6ccf846d0116fd132d46f3b8f8a9348f9edc46cec5d927e9b6f368ed1a310dc"
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

  on_macos do
    depends_on "libomp"
  end

  def python3
    which("python3.12")
  end

  # Add compat for numpy 2.0
  patch do
    url "https://github.com/networkit/networkit/commit/165503580caac864c7a31558b4c5fee27bcb007e.patch?full_index=1"
    sha256 "67bd2d1fe3ebccb42ccdd1f7cf5aeea40967caa4e9bc96cc69737dc14ffa9654"
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
