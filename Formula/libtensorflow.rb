class Libtensorflow < Formula
  desc "C interface for Google's OS library for Machine Intelligence"
  homepage "https://www.tensorflow.org/"
  url "https://github.com/tensorflow/tensorflow/archive/v1.13.1.tar.gz"
  sha256 "7cd19978e6bc7edc2c847bce19f95515a742b34ea5e28e4389dade35348f58ed"

  bottle do
    cellar :any
    sha256 "130969aee8e8813251c8d3711d26ab7bd434371618a7aee3d1c8f5d954345b21" => :mojave
    sha256 "4f867cc269c44fc8efb7e832471475108644dd1f0ae0d188bbdadd114c8e9af2" => :high_sierra
    sha256 "4fb898f8f698baa34c6c61df2a6280a5a6e7f058883cf6d2a35024264d25e235" => :sierra
  end

  depends_on "bazel" => :build
  depends_on :java => ["1.8", :build]

  # Allow libtensorflow to be built on bazel 0.22.0
  patch do
    url "https://github.com/tensorflow/tensorflow/commit/91da898cb6f6b0e751e15ceb813a37cdfe18a035.patch?full_index=1"
    sha256 "648295170a4d4226a76f916e61bf052dcd4b13e1c0517386a0e59963285cdc9b"
  end

  def install
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.popen_read(cmd).chomp

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
    ENV["TF_NEED_S3"] = "1"
    ENV["TF_NEED_GDR"] = "0"
    ENV["TF_NEED_KAFKA"] = "0"
    ENV["TF_NEED_OPENCL_SYCL"] = "0"
    ENV["TF_NEED_ROCM"] = "0"
    ENV["TF_DOWNLOAD_CLANG"] = "0"
    ENV["TF_SET_ANDROID_WORKSPACE"] = "0"
    system "./configure"

    system "bazel", "build", "--jobs", ENV.make_jobs, "--compilation_mode=opt", "--copt=-march=native", "tensorflow:libtensorflow.so"
    lib.install Dir["bazel-bin/tensorflow/*.so"]
    (include/"tensorflow/c").install "tensorflow/c/c_api.h"
    (lib/"pkgconfig/tensorflow.pc").write <<~EOS
      Name: tensorflow
      Description: Tensorflow library
      Version: #{version}
      Libs: -L#{lib} -ltensorflow
      Cflags: -I#{include}
    EOS
  end

  test do
    (testpath/"test.c").write <<~EOS
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
