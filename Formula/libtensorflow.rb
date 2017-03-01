class Libtensorflow < Formula
  desc "C interface for Google's OS library for Machine Intelligence"
  homepage "https://www.tensorflow.org/"
  url "https://github.com/tensorflow/tensorflow/archive/v1.0.0.tar.gz"
  sha256 "db8b3b8f4134b7c9c1b4165492ad5d5bb78889fcd99ffdffc325e97da3e8c677"

  bottle do
    cellar :any
    sha256 "019c831a1ce4136cf5868bdb62496469ade683245c08419a8cc045bb88f192bb" => :sierra
    sha256 "ef57183754f02645533cab1433b06a1d1fea4f330c61fd595c8a55ace2352982" => :el_capitan
    sha256 "0053d5d1e1be0cfad55508e11dc73b6b06f5c6a9cb37b58bb0526847c43d5b8a" => :yosemite
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
