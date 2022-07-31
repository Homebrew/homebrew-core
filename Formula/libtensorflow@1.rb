class LibtensorflowAT1 < Formula
  include Language::Python::Virtualenv

  desc "C interface for Google's OS library for Machine Intelligence"
  homepage "https://www.tensorflow.org/"
  url "https://github.com/tensorflow/tensorflow/archive/v1.15.5.tar.gz"
  sha256 "4c4d23e311093ded2d2e287b18d7c45b07b5984ab88a1d2f91f8f13c886123db"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, big_sur:  "8f1c80ebe024b29fb7d6695fa41de75e84d21948535a6459f3dd11b8e5a2165f"
    sha256 cellar: :any, catalina: "28bac51bae550468948151ffa7fa62d38cce9eee19522f045b1f40b4885f9625"
    sha256 cellar: :any, mojave:   "aefd6a0dbaae05e710a8372fa6ca3e6d731b9ee455ca99f898141d7f627303eb"
  end

  keg_only :versioned_formula

  disable! date: "2022-07-31", because: :versioned_formula

  depends_on "bazel" => :build
  depends_on "python@3.9" => :build

  def install
    ENV["PYTHON_BIN_PATH"] = Formula["python@3.9"].opt_bin/"python3"
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
