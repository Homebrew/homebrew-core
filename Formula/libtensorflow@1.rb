class LibtensorflowAT1 < Formula
  include Language::Python::Virtualenv

  desc "C interface for Google's OS library for Machine Intelligence"
  homepage "https://www.tensorflow.org/"
  url "https://github.com/tensorflow/tensorflow/archive/v1.15.3.tar.gz"
  sha256 "9ab1d92e58eb813922b040acc7622b32d73c2d8d971fe6491a06f9df4c778151"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "88440057fc88398f8b9affc4b60f4d8ac897a72403cad5a5a67d8c659ab79bfa" => :catalina
    sha256 "15fdb97131bdba58139f40ef7730e75aeba13a2440d2d9e3a67d36a51300c42a" => :mojave
    sha256 "bcf7c915fd8d97ffef810d5df53e16136de7e7c784a9b97a0474831c6d923ae5" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "bazel" => :build
  depends_on "python@3.8" => :build

  def install
    venv_root = "#{buildpath}/venv"
    virtualenv_create(venv_root, "python3")

    ENV["PYTHON_BIN_PATH"] = "#{venv_root}/bin/python"
    ENV["CC_OPT_FLAGS"] = "-march=native"
    ENV["TF_IGNORE_MAX_BAZEL_VERSION"] = "1"
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
    ENV["TF_CONFIGURE_IOS"] = "0"
    system "./configure"

    bazel_compatibility_flags = %w[
      --noincompatible_remove_legacy_whole_archive
    ]
    system "bazel", "build", "--jobs", ENV.make_jobs, "--compilation_mode=opt",
                    "--copt=-march=native", *bazel_compatibility_flags, "tensorflow:libtensorflow.so"
    lib.install Dir["bazel-bin/tensorflow/*.so*", "bazel-bin/tensorflow/*.dylib*"]
    (include/"tensorflow/c").install %w[
      tensorflow/c/c_api.h
      tensorflow/c/c_api_experimental.h
      tensorflow/c/tf_attrtype.h
      tensorflow/c/tf_datatype.h
      tensorflow/c/tf_status.h
      tensorflow/c/tf_tensor.h
    ]

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
    system ENV.cc, "-L#{lib}", "-I#{include}", "-ltensorflow", "-o", "test_tf", "test.c"
    assert_equal version, shell_output("./test_tf")
  end
end
