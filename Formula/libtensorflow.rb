class Libtensorflow < Formula
  desc "C interface for Google's OS library for Machine Intelligence"
  homepage "https://www.tensorflow.org/"
  url "https://github.com/tensorflow/tensorflow/archive/v1.3.1.tar.gz"
  sha256 "ded509c209f8a1d390df8a2f44be5b5c29963172b0e0f095304efb59765d0523"

  bottle do
    cellar :any
    sha256 "e6b5c9344af4d15c51a39ae59b1e0a405013f8760b8df2eac49d0a0abf61bd98" => :sierra
    sha256 "4ffd9fd2814401b290ddeaafecdebb3d99b2c4e8ef767a81d6ab4e83068ba535" => :el_capitan
    sha256 "0b7929c1fe2ae70b436ed439e6215105a719aa90d094afd525b3cf40d161a61d" => :yosemite
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
    ENV["TF_NEED_MPI"] = "0"
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
