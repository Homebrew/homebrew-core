class Networkit < Formula
  desc "Performance toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/refs/tags/11.3.tar.gz"
  sha256 "5aa5813110438270e9bb83c73f597943c4c5bedd5a9634fdaf5f2052a0053ba4"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c9985e3080312d841e42b6b7a74d72e49bd339b770941dde3aa8bb17d47ced89"
    sha256 cellar: :any, arm64_tahoe:       "aaff02040deb0eb23b43404e86e3034b8c34008737742ade042180253353e4cf"
    sha256 cellar: :any, arm64_sequoia:     "b971d6acbc5939fadb29fa7fe4971176262616ed316f0694a4bc9e011bb4be8c"
    sha256 cellar: :any, arm64_linux:       "6928954e1fb4ec0e4086db2b023821f3b6e486f8a2ad57698ca33983b2d1197b"
    sha256 cellar: :any, x86_64_linux:      "2410efe3e9b974b2fb2ef33442f436fa9e3bdfe4f472c314cf29e30ce1c26e0c"
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

  # Must match the `extlibs/dhb` submodule pinned by this release
  resource "dhb" do
    url "https://github.com/hu-macsy/dhb/archive/fb413abb5936ccf30d47e30a448cb8799c63b127.tar.gz"
    version "fb413abb5936ccf30d47e30a448cb8799c63b127"
    sha256 "3a0b726ce537359568cdf5e9ac73ff9606d7e6def1bf208a51d8f6971b3c0c2b"

    livecheck do
      url "https://api.github.com/repos/networkit/networkit/contents/extlibs/dhb?ref=#{LATEST_VERSION}"
      strategy :json do |json|
        json["sha"]
      end
    end
  end

  def install
    resource("dhb").stage buildpath/"extlibs/dhb"
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
