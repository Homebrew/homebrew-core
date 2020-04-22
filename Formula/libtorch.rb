class Libtorch < Formula
  include Language::Python::Virtualenv

  desc "Tensors and dynamic neural networks"
  homepage "https://pytorch.org/"
  url "https://github.com/pytorch/pytorch.git",
      :tag      => "v1.5.0",
      :revision => "4ff3872a2099993bf7e8c588f7182f3df777205b"

  bottle do
    cellar :any
    sha256 "8c02e1a2194a2c1136191b3a0420c02fcd9e7a8acda470ad8e2f6cc150c9b746" => :catalina
    sha256 "b8ea8eadabed75532d97ce7ae05e63e163d18e37ae419d7a23338e8caf5fd728" => :mojave
    sha256 "edbce157ec347c339e333cfd195f8a2e7ffbea598eb8fe4c00546762989d3e55" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python" => :build
  depends_on "eigen"
  depends_on "libomp"
  depends_on "libyaml"
  depends_on "protobuf"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/67/b0/b2ea2bd67bfb80ea5d12a5baa1d12bda002cab3b6c9b48f7708cd40c34bf/typing-3.7.4.1.tar.gz"
    sha256 "91dfe6f3f706ee8cc32d38edbbf304e9b7583fb37108fef38229617f8b3eba23"
  end

  # Fix compile with Apple Clang 10.
  patch do
    url "https://github.com/google/XNNPACK/commit/b18783570f0643560be641b193367d3906955141.patch?full_index=1"
    sha256 "5c17f0e38885ba48234cb89a9a0b101f9a760fa335efd1372b8fd1690dee5b21"
    directory "third_party/XNNPACK"
  end

  # Fix compile with Apple Clang 11.0.3.
  patch :DATA

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources

    args = %W[
      -DBUILD_CUSTOM_PROTOBUF=OFF
      -DBUILD_PYTHON=OFF
      -DPYTHON_EXECUTABLE=#{libexec}/bin/python
      -DUSE_CUDA=OFF
      -DUSE_METAL=OFF
      -DUSE_MKLDNN=OFF
      -DUSE_NNPACK=OFF
      -DUSE_SYSTEM_EIGEN_INSTALL=ON
    ]

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <torch/torch.h>
      #include <iostream>

      int main() {
        torch::Tensor tensor = torch::rand({2, 3});
        std::cout << tensor << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++14", "-L#{lib}", "-ltorch", "-ltorch_cpu", "-lc10",
      "-I#{include}/torch/csrc/api/include", "test.cpp", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/aten/src/ATen/native/SobolEngineOps.cpp b/aten/src/ATen/native/SobolEngineOps.cpp
index 8a14a22b8894..407d68a7e87d 100644
--- a/aten/src/ATen/native/SobolEngineOps.cpp
+++ b/aten/src/ATen/native/SobolEngineOps.cpp
@@ -134,7 +134,15 @@ Tensor& _sobol_engine_initialize_state_(Tensor& sobolstate, int64_t dimension) {
     int64_t m = bit_length(p) - 1;

     for (int64_t i = 0; i < m; ++i) {
-      ss_a[d][i] = initsobolstate[d][i];
+      // Note: [Workaround Clang9.0.0 bug]
+      // Q: Why not use `ss_a[d][i] = initsobolstate[d][i];`?
+      // A: It'll trigger a bug with Clang9.0.0 and segfaults pytorch build.
+      //    The bug is fixed in 9.0.1 but we still want to work around it
+      //    here so that we can keep using 9.0.0 in CircleCi jobs,
+      //    since it is available through apt.
+      //    See https://github.com/pytorch/pytorch/issues/36676 for details.
+      const auto p = &(initsobolstate[d]);
+      ss_a[d][i] = (*p)[i];
     }

     for (int64_t j = m; j < MAXBIT; ++j) {
