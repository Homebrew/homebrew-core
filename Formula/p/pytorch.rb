class Pytorch < Formula
  include Language::Python::Virtualenv

  desc "Tensors and dynamic neural networks"
  homepage "https://pytorch.org/"
  url "https://github.com/pytorch/pytorch/releases/download/v2.7.1/pytorch-v2.7.1.tar.gz"
  sha256 "5befd2e540fd55ce4782d0ca7610ce5b572d756d7ea38090ef0f3c7c428fb20f"
  license "BSD-3-Clause"

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
    url "https://files.pythonhosted.org/packages/0a/10/c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9a/filelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/00/f7/27f15d41f0ed38e8fcc488584b57e902b331da7f7c6dcda53721b15838fc/fsspec-2025.5.1.tar.gz"
    sha256 "2e55e47a540b91843b755e83ded97c6e897fa0942b11490113f09e9c443c2475"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
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
    url "https://files.pythonhosted.org/packages/6c/4f/ccdb8ad3a38e583f214547fd2f7ff1fc160c43a75af88e6aec213404b96a/networkx-3.5.tar.gz"
    sha256 "d4c6f9cf81f52d69230866796b82afbccdec3db7ae4fbd1b65ea750feed50037"
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
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/83/d3/803453b36afefb7c2bb238361cd4ae6125a569b4db67cd9e79846ba2d68c/sympy-1.14.0.tar.gz"
    sha256 "d3d3fe8df1e5a0b42f0e7bdf50541697dbe7d23746e894990c030e2b05e72517"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/98/5a/da40306b885cc8c09109dc2e1abd358d5684b1425678151cdaed4731c822/typing_extensions-4.14.1.tar.gz"
    sha256 "38b39f4aeeab64884ce9f74c94263ef78f3c22467c8724005483154c26648d36"
  end

  def install
    python3 = "python3.13"

    # Avoid building AVX512 code
    inreplace "cmake/Modules/FindAVX.cmake", /^CHECK_SSE\(CXX "AVX512"/, "#\\0"

    # avoid checking out disabled submodules
    inreplace "tools/build_pytorch_libs.py", "  checkout_nccl()", ""

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
    ENV["USE_KLEIDIAI"] = "OFF" if Hardware::CPU.arm?
    ENV["USE_MKLDNN"] = "OFF"
    ENV["USE_NNPACK"] = "OFF"
    ENV["USE_OPENMP"] = "ON"
    ENV["USE_SYSTEM_EIGEN_INSTALL"] = "ON"
    ENV["USE_SYSTEM_PYBIND11"] = "ON"
    ENV["USE_SYSTEM_SLEEF"] = "ON"
    ENV["USE_MPS"] = "ON" if OS.mac?

    # cmake 4 build patch for third parties
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

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

    # skipping the test on linux due to an error. Remove in next release
    return if OS.linux? && Hardware::CPU.intel?

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
