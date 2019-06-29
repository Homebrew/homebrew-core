class Libtensorflow < Formula
  include Language::Python::Virtualenv

  desc "C interface for Google's OS library for Machine Intelligence"
  homepage "https://www.tensorflow.org/"
  url "https://github.com/tensorflow/tensorflow/archive/v1.14.0.tar.gz"
  sha256 "aa2a6a1daafa3af66807cfe0bc77bfe1144a9a53df9a96bab52e3e575b3047ed"

  bottle do
    cellar :any
    sha256 "2df4c37601b1533a183473808acbf01444abcad0775ad2f5a699f6a3c0eba494" => :mojave
    sha256 "5a9d0ea0a8e3496388dd2892a144a2c627b445e356e0c8a2b7722b2ae54c6887" => :high_sierra
    sha256 "d9cc97a0c4b21dff9ccc3f511c90a820ff8ae857b82c06c812f1f2defe8b261b" => :sierra
  end

  depends_on "bazel" => :build
  depends_on :java => ["1.8", :build]
  depends_on "python" => :build

  # Allow libtensorflow to be built on bazel 0.28.0 (currently the latest available version)
  # this patch a consolidation of the following patches
  # - https://github.com/tensorflow/tensorflow/commit/c33055c44226499e99270ed05265ae3b960210c9 (from 0.25.2 to 0.25.3)
  # - https://github.com/tensorflow/tensorflow/commit/040546fdefc5a111496dcd7be97b7d65594f9119 (from 0.25.3 to 0.26.0)
  # - https://github.com/tensorflow/tensorflow/commit/c3260eb5ab384e4d03e7e8c840712380492b26d9 (from 0.26.0 to 0.26.1)
  # - Bump bazel from 0.26.1 to 0.28.0
  patch :DATA

  # Upgrade protobuf to 3.8.0
  # The custom commit contains a fix to make protobuf.bzl compatible with Bazel 0.26 or later version.
  patch do
    url "https://github.com/tensorflow/tensorflow/commit/508f76b1d9925304cedd56d51480ec380636cb82.diff?full_index=1"
    sha256 "89f09f266ee56ee583cfffb8b4ce9333f181f497f7e04a672a68a8b611d21270"
  end

  def install
    venv_root = "#{buildpath}/venv"
    virtualenv_create(venv_root, "python3")

    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.popen_read(cmd).chomp

    ENV["PYTHON_BIN_PATH"] = "#{venv_root}/bin/python"
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
    lib.install Dir["bazel-bin/tensorflow/*.so*", "bazel-bin/tensorflow/*.dylib*"]
    (include/"tensorflow/c").install ["tensorflow/c/c_api.h", "tensorflow/c/c_api_experimental.h", "tensorflow/c/tf_attrtype.h"]

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

__END__
diff --git a/configure.py b/configure.py
index 43af22de88..7b0d99f04d 100644
--- a/configure.py
+++ b/configure.py
@@ -1383,7 +1383,7 @@ def main():
   # environment variables.
   environ_cp = dict(os.environ)

-  current_bazel_version = check_bazel_version('0.24.1', '0.25.2')
+  current_bazel_version = check_bazel_version('0.24.1', '0.28.0')
   _TF_CURRENT_BAZEL_VERSION = convert_version_to_int(current_bazel_version)

   reset_tf_configure_bazelrc()
