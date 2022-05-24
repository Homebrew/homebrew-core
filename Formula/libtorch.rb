class Libtorch < Formula
  include Language::Python::Virtualenv

  desc "Tensors and dynamic neural networks"
  homepage "https://pytorch.org/"
  url "https://github.com/pytorch/pytorch.git",
      tag:      "v1.11.0",
      revision: "bc2c6edaf163b1a1330e37a6e34caf8c553e4755"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9cef2e0f8cdb87009872fad2ec9266604f4113e9529140634a44e62a97e5638b"
    sha256 cellar: :any,                 arm64_big_sur:  "3f802f699fd15c47dfb3555829d6884ff08acf08e28b4ea3f6902c751f7c04c5"
    sha256 cellar: :any,                 monterey:       "04d8e1946675f2a9b00292ba3df4c689cd067cd8d7d3deb1db7f3e1934a30278"
    sha256 cellar: :any,                 big_sur:        "72cfc52919ca46635abda388937059226948919a934c2aa9765506e0f1767c91"
    sha256 cellar: :any,                 catalina:       "abb5e3fcff89f1d910d262d695c701f33f2e38ded91a5de8fa32e552b8b9bc7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b60017c84c52e68ecf87ab24bcdd8d603a583409ede61b58e67bd86fcbddbac7"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build
  depends_on "eigen"
  depends_on "libomp"
  depends_on "libyaml"
  depends_on "protobuf"
  depends_on "pybind11"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/b1/5a/8b5fbb891ef3f81fc923bf3cb4a578c0abf9471eb50ce0f51c74212182ab/typing_extensions-4.1.1.tar.gz"
    sha256 "1a9462dcc3347a79b1f1c0271fbe79e844580bb598bafa1ed208b94da3cdcd42"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", Formula["python@3.10"].opt_bin/"python3")
    venv.pip_install resources

    args = %W[
      -DBUILD_CUSTOM_PROTOBUF=OFF
      -DBUILD_PYTHON=OFF
      -DPYTHON_EXECUTABLE=#{buildpath}/venv/bin/python
      -DUSE_CUDA=OFF
      -DUSE_METAL=OFF
      -DUSE_MKLDNN=OFF
      -DUSE_NNPACK=OFF
      -DUSE_OPENMP=ON
      -DUSE_SYSTEM_EIGEN_INSTALL=ON
      -DUSE_SYSTEM_PYBIND11=ON
    ]
    # Remove when https://github.com/pytorch/pytorch/issues/67974 is addressed
    args << "-DUSE_SYSTEM_BIND11=ON"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, *args

      # Avoid references to Homebrew shims
      inreplace "caffe2/core/macros.h", Superenv.shims_path/ENV.cxx, ENV.cxx

      system "cmake", "--build", ".", "--target", "install"
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
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test",
                    "-I#{include}/torch/csrc/api/include",
                    "-L#{lib}", "-ltorch", "-ltorch_cpu", "-lc10"
    system "./test"
  end
end
