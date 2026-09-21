class Networkit < Formula
  desc "Performance toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/refs/tags/11.2.2.tar.gz"
  sha256 "04fffd0f801a91524a6dc2643f7d262e79600b086e4688bcb1b7988b2b5448dd"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f5648fc41e771dad414a0e5373a68cb6972a72492f95e723c8a4687aaf560253"
    sha256 cellar: :any, arm64_tahoe:       "5e652ca9e62b405b5433da7a9142150d55789074069d7db242f463c4e851b2fe"
    sha256 cellar: :any, arm64_sequoia:     "db98c836a5a215c45ff27363e1fb0d3c73452c272317b87440d3271f21275f16"
    sha256               arm64_linux:       "a4c1348e4668eee24955e129f432b8e8ff314e6e56ad230fa05ed4d7ca469fe0"
    sha256               x86_64_linux:      "e606cd5834dc59789320cbd57bb73b237fb7ee6e67a43bf309517d53c5eefb7c"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "ninja" => :build
  depends_on "python-setuptools" => :build
  depends_on "tlx" => :build

  depends_on "libnetworkit"
  depends_on "numpy"
  depends_on "python@3.14"
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
