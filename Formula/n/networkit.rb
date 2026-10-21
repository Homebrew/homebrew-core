class Networkit < Formula
  desc "Performance toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/refs/tags/11.2.2.tar.gz"
  sha256 "04fffd0f801a91524a6dc2643f7d262e79600b086e4688bcb1b7988b2b5448dd"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "059710b0c965b189255a4835dfa00581368d05caff093c83a5c014d641bf06ff"
    sha256 cellar: :any, arm64_tahoe:       "b4a97fe8392462ce1f5911048941876f84e5880cc0624ccb937359ed78571c00"
    sha256 cellar: :any, arm64_sequoia:     "35381f2336244806798ce5d858e467987ed1b674e7f841fc45d4accccd1c56ea"
    sha256               arm64_linux:       "fc8409d586e1a06ee7558a1f05dde0b97f0c3559b9dc531a114f8a520f4a731d"
    sha256               x86_64_linux:      "63d9a7c0219912d782a4cae207e5101746dd8a9053b859ef842b15094e91a43d"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "ninja" => :build
  depends_on "python-setuptools" => :build
  depends_on "tlx" => :build

  depends_on "libnetworkit"
  depends_on "numpy"
  depends_on "python@3.15"
  depends_on "scipy"

  on_macos do
    depends_on "libomp"
  end

  # Fix build with Cython 3.3 (duplicate `__pyx_convert_vector_to_py_*` definitions)
  patch do
    url "https://github.com/networkit/networkit/commit/11bbe357057f886ef8864565f981c4f86a47b8ce.patch?full_index=1"
    sha256 "495247630a1a1810c6db057b58c27a82777710e7a9ec77e2c6abdeff18e6919d"
    type :unofficial
    resolves "https://github.com/networkit/networkit/pull/1519"
  end

  def install
    site_packages = Language::Python.site_packages(python3)

    ENV.prepend_create_path "PYTHONPATH", prefix/site_packages
    ENV.append_path "PYTHONPATH", formula_opt_libexec("cython")/site_packages

    networkit_site_packages = prefix/site_packages/"networkit"
    extra_rpath = rpath(source: networkit_site_packages, target: formula_opt_lib("libnetworkit"))
    system python3, "setup.py", "build_ext", "--networkit-external-core",
                                             "--external-tlx=#{formula_opt_prefix("tlx")}",
                                             "--rpath=#{loader_path};#{extra_rpath}"

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system python3, "-c", <<~PYTHON
      import networkit as nk
      G = nk.graph.Graph(3)
      G.addEdge(0,1)
      G.addEdge(1,2)
      G.addEdge(2,0)
      assert G.degree(0) == 2
      assert G.degree(1) == 2
      assert G.degree(2) == 2
    PYTHON
  end
end
