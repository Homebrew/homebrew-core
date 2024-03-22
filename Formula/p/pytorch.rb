class Pytorch < Formula
  include Language::Python::Virtualenv

  desc "Tensors and dynamic neural networks"
  homepage "https://pytorch.org/"
  url "https://github.com/pytorch/pytorch/releases/download/v2.2.0/pytorch-v2.2.0.tar.gz"
  sha256 "e12d18c3dbb12d7ae2f61f5ab9a21023e3dd179d67ed87279ef96600b9ac08c5"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d19eb1f98db2934936fbd13a2884350adb1463a938244e72ee735dd512ddc25f"
    sha256 cellar: :any,                 arm64_ventura:  "e3f64481fdacdb833c9b09bdd9815e905d382c55e923e0070185efb8aeeba70f"
    sha256 cellar: :any,                 arm64_monterey: "2ae2435a879b5113ffe899468a5305e882a70276a1f5dfc72adff03740007858"
    sha256 cellar: :any,                 sonoma:         "a160b1fa09a53a600731c6cee93268bf0e69bd9efeb40b6528b64060c895f06a"
    sha256 cellar: :any,                 ventura:        "6cabf7348d4be33524e01910da47eb1f743e96ecff3c79edc6a3013f6dde693b"
    sha256 cellar: :any,                 monterey:       "580f0bc70869f04fa8aa93e4c47298ca959812d7d620017cae296208c0c687d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19e14272992b65c3f77379eb9c3a54c8d46e2d8d7ec1b76fb94853b7652714f9"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on xcode: :build
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
    url "https://files.pythonhosted.org/packages/70/70/41905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263/filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/28/d3/c2e0403c735548abf991bba3f45ba39194dff4569f76a99fbe77078ba7c5/fsspec-2024.2.0.tar.gz"
    sha256 "b6ad1a679f760dda52b1168c859d01b7b80648ea6f7f7c7f5a8a91dc3f3ecb84"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/b2/5e/3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1/Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "mpmath" do
    url "https://files.pythonhosted.org/packages/e0/47/dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57/mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/c4/80/a84676339aaae2f1cfdf9f418701dd634aef9cc76f708ef55c36ff39c3ca/networkx-3.2.1.tar.gz"
    sha256 "9f1bb5cf3409bf324e0a722c20bdb4c20ee39bf1c30ce8ae499c8502b0b5e0c6"
  end

  resource "opt-einsum" do
    url "https://files.pythonhosted.org/packages/7d/bf/9257e53a0e7715bc1127e15063e831f076723c6cd60985333a1c18878fb8/opt_einsum-3.3.0.tar.gz"
    sha256 "59f6475f77bbc37dcf7cd748519c0ec60722e91e63ca114e68821c0c54a46549"

    # Backport ConfigParser fix for Python 3.12 support
    patch do
      url "https://github.com/dgasmith/opt_einsum/commit/7c8f193f90b6771a6b3065bb5cf6ec2747af8209.patch?full_index=1"
      sha256 "7c90ac470278deca8aa9d7ecb4bb2b31a2f79928e1783ae1316fcc3aa81f348a"
    end
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c8/1f/e026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44/setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/e5/57/3485a1a3dff51bfd691962768b14310dae452431754bfc091250be50dd29/sympy-1.12.tar.gz"
    sha256 "ebf595c8dac3e0fdc4152c51878b498396ec7f30e7a914d6071e674d49420fb8"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0c/1d/eb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96/typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  # Backport usage of SLEEF_CONST from upstream commit
  # Ref: https://github.com/pytorch/pytorch/commit/2b060983809e5fe8706acd085fff67b6a27bfb5f
  patch :DATA

  def install
    python3 = "python3.12"

    ENV["ATEN_NO_TEST"] = "ON"
    ENV["BLAS"] = "OpenBLAS"
    ENV["BUILD_CUSTOM_PROTOBUF"] = "OFF"
    ENV["BUILD_PYTHON"] = "ON"
    ENV["BUILD_TEST"] = "OFF"
    ENV["PYTHON_EXECUTABLE"] = which(python3)
    ENV["USE_CUDA"] = "OFF"
    ENV["USE_DISTRIBUTED"] = "ON"
    ENV["USE_METAL"] = "OFF"
    ENV["USE_MKLDNN"] = "OFF"
    ENV["USE_NNPACK"] = "OFF"
    ENV["USE_OPENMP"] = "ON"
    ENV["USE_SYSTEM_EIGEN_INSTALL"] = "ON"
    ENV["USE_SYSTEM_PYBIND11"] = "ON"
    ENV["USE_SYSTEM_SLEEF"] = "ON"
    ENV["USE_MPS"] = "ON" if OS.mac?

    # Work around superenv removing `-Werror=` but leaving `-Wno-error=` breaking flag detection
    if ENV.compiler.to_s.start_with?("gcc")
      inreplace "CMakeLists.txt", 'append_cxx_flag_if_supported("-Wno-error=inconsistent-missing-', "# \\0"
    end

    # Avoid references to Homebrew shims
    inreplace "caffe2/core/macros.h.in", "${CMAKE_CXX_COMPILER}", ENV.cxx

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    venv.pip_install_and_link(buildpath, build_isolation: false)

    # Expose C++ API
    torch = libexec/Language::Python.site_packages(python3)/"torch"
    include.install_symlink (torch/"include").children
    lib.install_symlink (torch/"lib").children
    (share/"cmake").install_symlink (torch/"share/cmake").children
  end

  test do
    # test that C++ libraries are available
    (testpath/"test.cpp").write <<~EOS
      #include <torch/torch.h>
      #include <iostream>

      int main() {
        torch::Tensor tensor = torch::rand({2, 3});
        std::cout << tensor << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
                    "-I#{include}/torch/csrc/api/include",
                    "-L#{lib}", "-ltorch", "-ltorch_cpu", "-lc10"
    system "./test"

    # test that the `torch` Python module is available
    system libexec/"bin/python", "-c", <<~EOS
      import torch
      t = torch.rand(5, 3)
      assert isinstance(t, torch.Tensor), "not a tensor"
      assert torch.distributed.is_available(), "torch.distributed is unavailable"
    EOS

    if OS.mac?
      # test that we have the MPS backend
      system libexec/"bin/python", "-c", <<~EOS
        import torch
        assert torch.backends.mps.is_built(), "MPS backend is not built"
      EOS
    end
  end
end

__END__
diff --git a/aten/src/ATen/cpu/vec/vec256/vec256_bfloat16.h b/aten/src/ATen/cpu/vec/vec256/vec256_bfloat16.h
index 3e26213d6d26609b2cda7bde2d026fc92c626db2..edda0210746530bb60765939e90899083f8be595 100644
--- a/aten/src/ATen/cpu/vec/vec256/vec256_bfloat16.h
+++ b/aten/src/ATen/cpu/vec/vec256/vec256_bfloat16.h
@@ -265,7 +266,8 @@ static_assert(
     }
     return b;
   }
-  Vectorized<T> map(const __m256 (*const vop)(__m256)) const {
+
+  Vectorized<T> map(SLEEF_CONST __m256 (*vop)(__m256)) const {
     __m256 lo, hi;
     cvt_to_fp32<T>(values, lo, hi);
     const auto o1 = vop(lo);
diff --git a/aten/src/ATen/cpu/vec/vec512/vec512_bfloat16.h b/aten/src/ATen/cpu/vec/vec512/vec512_bfloat16.h
index f9fc92d52bfe0c8ea594384beecf4da47961faa0..6513455283e2be3e588fd15131c5d48a17e107bb 100644
--- a/aten/src/ATen/cpu/vec/vec512/vec512_bfloat16.h
+++ b/aten/src/ATen/cpu/vec/vec512/vec512_bfloat16.h
@@ -362,7 +363,8 @@ static_assert(
   }
   #pragma clang diagnostic push
   #pragma clang diagnostic ignored "-Wignored-qualifiers"
-  Vectorized<T> map(const __m512 (*const vop)(__m512)) const {
+
+  Vectorized<T> map(SLEEF_CONST __m512 (*vop)(__m512)) const {
     __m512 lo, hi;
     cvt_to_fp32<T>(values, lo, hi);
     const auto o1 = vop(lo);
