class Pytorch < Formula
  include Language::Python::Virtualenv

  desc "Tensors and dynamic neural networks"
  homepage "https://pytorch.org/"
  url "https://github.com/pytorch/pytorch/releases/download/v2.5.1/pytorch-v2.5.1.tar.gz"
  sha256 "740eb5fff95e33cfe699bad43be83523f569c7cc7f9c285c2a255416443dd266"
  license "BSD-3-Clause"
  revision 4

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ec01ffac0aa0b57f68f549662c25d92a1dad3f2e339f7c3dc854170c17605971"
    sha256 cellar: :any,                 arm64_sonoma:  "5014d4b9765a0d095e999622a2d3dd11b86fe35cd3fdbd8326c650899ec9fba8"
    sha256 cellar: :any,                 arm64_ventura: "c605e16c0afed8013bb521270d19b816709769962b2a086faa22dcd131a11e06"
    sha256 cellar: :any,                 sonoma:        "3385569ccb7ac7be5aabdbd7011b30f99c646ce1c78b6857c73cf5f63ee5f0de"
    sha256 cellar: :any,                 ventura:       "3e7459213ca3d58b131768f6fe0b89b1f0054fc39a9ca0d80a1ea5bd6bdc307d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba32d918d891c1ad8f8b76c128599dac25cba702616f32d21a0b66402b77c8bd"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on xcode: :build
  depends_on "abseil"
  depends_on "eigen"
  depends_on "libuv"
  depends_on "libyaml"
  depends_on macos: :monterey # MPS backend only supports 12.3 and above
  depends_on "numpy"
  depends_on "openblas"
  depends_on "protobuf"
  depends_on "pybind11"
  depends_on "sleef"

  on_macos do
    depends_on "libomp"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/9d/db/3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1/filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/62/7c/12b0943011daaaa9c35c2a2e22e5eb929ac90002f08f1259d69aedad84de/fsspec-2024.9.0.tar.gz"
    sha256 "4b0afb90c2f21832df142f292649035d80b421f60a9e1c027802e5a0da2b04e8"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mpmath" do
    url "https://files.pythonhosted.org/packages/e0/47/dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57/mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/36/2b/20ad9eecdda3f1b0dc63fb8f82d2ea99163dbca08bfa392594fc2ed81869/networkx-3.4.1.tar.gz"
    sha256 "f9df45e85b78f5bd010993e897b4f1fdb242c11e015b101bd951e5c0e29982d8"
  end

  resource "opt-einsum" do
    url "https://files.pythonhosted.org/packages/8c/b9/2ac072041e899a52f20cf9510850ff58295003aa75525e58343591b0cbfb/opt_einsum-3.4.0.tar.gz"
    sha256 "96ca72f1b886d148241348783498194c577fa30a8faac108586b14f1ba4473ac"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/07/37/b31be7e4b9f13b59cde9dcaeff112d401d49e0dc5b37ed4a9fc8fb12f409/setuptools-75.2.0.tar.gz"
    sha256 "753bb6ebf1f465a1912e19ed1d41f403a79173a9acf66a42e7e6aec45c3c16ec"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/ca/99/5a5b6f19ff9f083671ddf7b9632028436167cd3d33e11015754e41b249a4/sympy-1.13.1.tar.gz"
    sha256 "9cebf7e04ff162015ce31c9c6c9144daa34a93bd082f54fd8f12deca4f47515f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  def install
    python3 = "python3.13"

    # Avoid building AVX512 code
    inreplace "cmake/Modules/FindAVX.cmake", /^CHECK_SSE\(CXX "AVX512"/, "#\\0"

    ENV["ATEN_NO_TEST"] = "ON"
    ENV["BLAS"] = "OpenBLAS"
    ENV["BUILD_CUSTOM_PROTOBUF"] = "OFF"
    ENV["BUILD_PYTHON"] = "ON"
    ENV["BUILD_TEST"] = "OFF"
    ENV["PYTHON_EXECUTABLE"] = which(python3)
    ENV["PYTORCH_BUILD_VERSION"] = version.to_s
    ENV["PYTORCH_BUILD_NUMBER"] = "1"
    ENV["USE_CCACHE"] = "OFF"
    ENV["USE_CUDA"] = "OFF"
    ENV["USE_DISTRIBUTED"] = "ON"
    ENV["USE_MKLDNN"] = "OFF"
    ENV["USE_NNPACK"] = "OFF"
    ENV["USE_OPENMP"] = "ON"
    ENV["USE_SYSTEM_EIGEN_INSTALL"] = "ON"
    ENV["USE_SYSTEM_PYBIND11"] = "ON"
    ENV["USE_SYSTEM_SLEEF"] = "ON"
    ENV["USE_MPS"] = "ON" if OS.mac?

    # Avoid references to Homebrew shims
    inreplace "caffe2/core/macros.h.in", "${CMAKE_CXX_COMPILER}", ENV.cxx

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    venv.pip_install_and_link(buildpath, build_isolation: false)

    # Expose C++ API
    torch = venv.site_packages/"torch"
    include.install_symlink (torch/"include").children
    lib.install_symlink (torch/"lib").children
    (share/"cmake").install_symlink (torch/"share/cmake").children
  end

  test do
    # test that C++ libraries are available
    (testpath/"test.cpp").write <<~CPP
      #include <torch/torch.h>
      #include <iostream>

      int main() {
        torch::Tensor tensor = torch::rand({2, 3});
        std::cout << tensor << std::endl;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
                    "-I#{include}/torch/csrc/api/include",
                    "-L#{lib}", "-ltorch", "-ltorch_cpu", "-lc10"
    system "./test"

    # test that the `torch` Python module is available
    system libexec/"bin/python", "-c", <<~PYTHON
      import torch
      t = torch.rand(5, 3)
      assert isinstance(t, torch.Tensor), "not a tensor"
      assert torch.distributed.is_available(), "torch.distributed is unavailable"
    PYTHON
    return unless OS.mac?

    # test that we have the MPS backend
    system libexec/"bin/python", "-c", <<~PYTHON
      import torch
      assert torch.backends.mps.is_built(), "MPS backend is not built"
    PYTHON
  end
end
