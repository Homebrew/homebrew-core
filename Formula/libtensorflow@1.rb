class LibtensorflowAT1 < Formula
  include Language::Python::Virtualenv

  desc "C interface for Google's OS library for Machine Intelligence"
  homepage "https://www.tensorflow.org/"
  url "https://github.com/tensorflow/tensorflow/archive/v1.15.0.tar.gz"
  sha256 "a5d49c00a175a61da7431a9b289747d62339be9cf37600330ad63b611f7f5dc9"

  bottle do
    cellar :any
    sha256 "4d61e319358885f1c6c8c032ad0f932cdf58fa8a123569236100e26612d9a72b" => :catalina
    sha256 "4d61e319358885f1c6c8c032ad0f932cdf58fa8a123569236100e26612d9a72b" => :mojave
    sha256 "140a9c31737c91e350f9867f34986d8f74ba4307afd9c15413f137e84aae38f2" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "bazel" => :build
  depends_on :java => ["1.8", :build]
  depends_on "python" => :build

  def install
    venv_root = "#{buildpath}/venv"
    virtualenv_create(venv_root, "python3")

    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.popen_read(cmd).chomp

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
    system "bazel", "build", "--jobs", ENV.make_jobs, "--compilation_mode=opt", "--copt=-march=native", *bazel_compatibility_flags, "tensorflow:libtensorflow.so"
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
