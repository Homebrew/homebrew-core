class Libtensorflow < Formula
  desc "C interface for Google's OS library for Machine Intelligence"
  homepage "https://www.tensorflow.org/"
  url "https://github.com/tensorflow/tensorflow/archive/v1.2.0.tar.gz"
  sha256 "03dbf7548d1fc1c11ed58da5fa68616f795c819f868f43478cbcaa26abed374f"

  bottle do
    cellar :any
    sha256 "09c17052b8500ca29b16e0b0cf897ff2f1fa1ac58dbb1f8379620f74727cbe75" => :sierra
    sha256 "5253b9433228b62e9db77e03ad76f2d03960c9e8e5d7c3888c44c9f090b38c4b" => :el_capitan
    sha256 "148f9ee2c1a09e20dbbe126212494e76aa8a699801cd8a1f5838d8d4534f0d4d" => :yosemite
  end

  depends_on "bazel" => :build

  def install
    ENV["PYTHON_BIN_PATH"] = which("python").to_s
    ENV["CC_OPT_FLAGS"] = "-march=native"
    ENV["TF_NEED_JEMALLOC"] = "1"
    ENV["TF_NEED_GCP"] = "0"
    ENV["TF_NEED_HDFS"] = "0"
    ENV["TF_ENABLE_XLA"] = "0"
    ENV["USE_DEFAULT_PYTHON_LIB_PATH"] = "1"
    ENV["TF_NEED_OPENCL"] = "0"
    ENV["TF_NEED_CUDA"] = "0"
    ENV["TF_NEED_MKL"] = "0"
    ENV["TF_NEED_VERBS"] = "0"
    system "./configure"

    system "bazel", "build", "--compilation_mode=opt", "--copt=-march=native", "tensorflow:libtensorflow.so"
    lib.install "bazel-bin/tensorflow/libtensorflow.so"
    (include/"tensorflow/c").install "tensorflow/c/c_api.h"
    (lib/"pkgconfig/tensorflow.pc").write <<-EOS.undent
      Name: tensorflow
      Description: Tensorflow library
      Version: #{version}
      Libs: -L#{lib} -ltensorflow
      Cflags: -I#{include}
    EOS
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <tensorflow/c/c_api.h>
      int main() {
        printf("%s", TF_Version());
      }
    EOS
    system ENV.cc, "-L#{lib}", "-ltensorflow", "-o", "test_tf", "test.c"
    assert_equal version, shell_output("./test_tf")
  end
end
