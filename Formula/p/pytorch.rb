class Pytorch < Formula
  include Language::Python::Virtualenv

  desc "Tensors and dynamic neural networks"
  homepage "https://pytorch.org/"
  url "https://github.com/pytorch/pytorch/releases/download/v2.10.0/pytorch-v2.10.0.tar.gz"
  sha256 "fa8ccbe87f83f48735505371c1c313b4aa6db400b0ae4f8a02844d1e150c695f"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1fdb982bd44569c59eee93c00b077f176faf85fc34c5d6ff139a3619c843fce9"
    sha256 cellar: :any, arm64_sequoia: "e35118ea4fd3d74157f5aa9572809e3129c79cec5f3220294893891a9612189c"
    sha256 cellar: :any, arm64_sonoma:  "7ae1f37acbb2c43e1b8f21eb8325f4bd68bbdca58ce5d9a51bbe5372138ef8c2"
    sha256 cellar: :any, sonoma:        "619c5aabd0994910640f9657de0c3be693af529081db9fcb578e157b8654ce8a"
    sha256               arm64_linux:   "b2d6d3495d201287fa31984f4b2c5b0f7413b9edbcc26f860051216707be41f8"
    sha256               x86_64_linux:  "b14466e5f1aa3de2b11cc726556472d49edb3085a8dd8b6158f95881b36abc95"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.14" => [:build, :test]
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

  pypi_packages package_name:     "torch[opt-einsum]",
                extra_packages:   %w[pyyaml packaging],
                exclude_packages: "numpy"

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/1d/65/ce7f1b70157833bf3cb851b556a37d4547ceafc158aa9b34b36782f23696/filelock-3.20.3.tar.gz"
    sha256 "18c57ee915c7ec61cff0ecf7f0f869936c7c30191bb0cf406f1341778d0834e1"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/d5/7d/5df2650c57d47c57232af5ef4b4fdbff182070421e405e0d62c6cdbfaa87/fsspec-2026.1.0.tar.gz"
    sha256 "e987cb0496a0d81bba3a9d1cee62922fb395e7d4c3b575e57f547953334fe07b"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mpmath" do
    url "https://files.pythonhosted.org/packages/e0/47/dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57/mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/6a/51/63fe664f3908c97be9d2e4f1158eb633317598cfa6e1fc14af5383f17512/networkx-3.6.1.tar.gz"
    sha256 "26b7c357accc0c8cde558ad486283728b65b6a95d85ee1cd66bafab4c8168509"
  end

  resource "opt-einsum" do
    url "https://files.pythonhosted.org/packages/8c/b9/2ac072041e899a52f20cf9510850ff58295003aa75525e58343591b0cbfb/opt_einsum-3.4.0.tar.gz"
    sha256 "96ca72f1b886d148241348783498194c577fa30a8faac108586b14f1ba4473ac"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/86/ff/f75651350db3cf2ef767371307eb163f3cc1ac03e16fdf3ac347607f7edb/setuptools-80.10.1.tar.gz"
    sha256 "bf2e513eb8144c3298a3bd28ab1a5edb739131ec5c22e045ff93cd7f5319703a"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/83/d3/803453b36afefb7c2bb238361cd4ae6125a569b4db67cd9e79846ba2d68c/sympy-1.14.0.tar.gz"
    sha256 "d3d3fe8df1e5a0b42f0e7bdf50541697dbe7d23746e894990c030e2b05e72517"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def install
    python3 = "python3.14"

    # Avoid building AVX512 code
    inreplace "cmake/Modules/FindAVX.cmake", /^CHECK_SSE\(CXX "AVX512"/, "#\\0"

    # Disable SVE support as it requires enabling support in `sleef` formula.
    # This is not recommended as SLEEF is moving SVE support to unmaintained status:
    # https://github.com/shibatch/sleef/discussions/673#discussioncomment-12610711
    inreplace "cmake/Modules/FindARM.cmake", /^\s*CHECK_COMPILES\(CXX "SVE256"/, "#\\0"

    # Avoid bundling libomp
    inreplace "setup.py", /^(\s*)self\._embed_libomp\(\)$/, "\\1pass"

    ENV["ATEN_NO_TEST"] = "ON"
    ENV["BLAS"] = "OpenBLAS"
    ENV["BUILD_CUSTOM_PROTOBUF"] = "OFF"
    ENV["BUILD_PYTHON"] = "ON"
    ENV["BUILD_TEST"] = "OFF"
    ENV["OpenBLAS_HOME"] = Formula["openblas"].opt_prefix
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
    ENV["USE_KLEIDIAI"] = "OFF"

    # Workaround for
    # error: a template argument list is expected after a name prefixed by the template keyword
    ENV.append_to_cflags "-Wmissing-template-arg-list-after-template-kw"

    # Avoid references to Homebrew shims
    inreplace "caffe2/core/macros.h.in", "${CMAKE_CXX_COMPILER}", ENV.cxx

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    # PyTorch needs to pass `-march=armv8.2-a+fp16` to compile runtime detected code
    ENV.runtime_cpu_detection if OS.linux? && Hardware::CPU.arch == :arm64

    venv.pip_install_and_link(buildpath, build_isolation: false)

    # Expose C++ API
    torch = venv.site_packages/"torch"
    include.install_symlink ((torch/"include").children - [torch/"include/fmt"])
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
