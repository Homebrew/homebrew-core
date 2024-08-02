class Pytorch < Formula
  include Language::Python::Virtualenv

  desc "Tensors and dynamic neural networks"
  homepage "https://pytorch.org/"
  url "https://github.com/pytorch/pytorch/releases/download/v2.3.1/pytorch-v2.3.1.tar.gz"
  sha256 "6c66b59345091907cd62a693b647cee224558e7f15a9b04f4f322f4f6ffeb75b"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2ce0c2c997fe49524dc77db68e07a68899b6e6e2fd646bba1a576884486e11b7"
    sha256 cellar: :any,                 arm64_ventura:  "027deccaa19afe466fb3cb27007c8c2c9974dea430dda3aa3f42cc1e59668c73"
    sha256 cellar: :any,                 arm64_monterey: "64d191f257885820a2570407a5241297aa002ccaf0ca744a5408ffc0c9be181f"
    sha256 cellar: :any,                 sonoma:         "a8366c033d59728a450a360b70f3719d9f5d61425728303421dc734f16b8819a"
    sha256 cellar: :any,                 ventura:        "2de520a5b202acdbb3db837d48e233837d1ce294f403790fd8e4bf6d9131636d"
    sha256 cellar: :any,                 monterey:       "c8ffe8854466c3797273caf32e6bc364738936cfa6895fe1f7303d862c883ef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c71ba6cb22a006da7a25ac01791d60d8b633359ead5eec463834150affdb0ad9"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.12" => [:build, :test]
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
    url "https://files.pythonhosted.org/packages/08/dd/49e06f09b6645156550fb9aee9cc1e59aba7efbc972d665a1bd6ae0435d4/filelock-3.15.4.tar.gz"
    sha256 "2207938cbc1844345cb01a5a95524dae30f0ce089eba5b00378295a17e3e90cb"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/90/b6/eba5024a9889fcfff396db543a34bef0ab9d002278f163129f9f01005960/fsspec-2024.6.1.tar.gz"
    sha256 "fad7d7e209dd4c1208e3bbfda706620e0da5142bebbd9c384afb95b07e798e49"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
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
    url "https://files.pythonhosted.org/packages/04/e6/b164f94c869d6b2c605b5128b7b0cfe912795a87fc90e78533920001f3ec/networkx-3.3.tar.gz"
    sha256 "0c127d8b2f4865f59ae9cb8aafcd60b5c70f3241ebd66f7defad7c4ab90126c9"
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
    url "https://files.pythonhosted.org/packages/d6/4f/b10f707e14ef7de524fe1f8988a294fb262a29c9b5b12275c7e188864aed/setuptools-69.5.1.tar.gz"
    sha256 "6c1fccdac05a97e598fb0ae3bbed5904ccb317337a51139dcd51453611bbb987"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/41/8a/0d1bbd33cd3091c913d298746e56f40586fa954788f51b816c6336424675/sympy-1.12.1.tar.gz"
    sha256 "2877b03f998cd8c08f07cd0de5b767119cd3ef40d09f41c30d722f6686b0fb88"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
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
