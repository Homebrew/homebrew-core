class Libtensorflow < Formula
  include Language::Python::Virtualenv

  desc "C interface for Google's OS library for Machine Intelligence"
  homepage "https://www.tensorflow.org/"
  url "https://github.com/tensorflow/tensorflow/archive/v2.2.0.tar.gz"
  sha256 "69cd836f87b8c53506c4f706f655d423270f5a563b76dc1cfa60fbc3184185a3"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "bc58f2c31ada1e7d076e828c763c577a1fed4f218c9408faf92fc56d34cc9661" => :catalina
    sha256 "c033286edc730d36b7945f03dacb8b3269d25f661d4c3f933c4351959ebd5782" => :mojave
    sha256 "c6f36dbbd5f111f6fb0808bd849bee4b3d95f1dc416d37ea458b27f0d00206cf" => :high_sierra
  end

  depends_on "bazel" => :build
  depends_on "openjdk" => :build
  depends_on "python@3.8" => :build

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/2d/f3/795e50e3ea2dc7bc9d1a2eeea9997d5dce63b801e08dfc37c2efce341977/numpy-1.18.4.zip"
    sha256 "bbcc85aaf4cd84ba057decaead058f43191cc0e30d6bc5d44fe336dc3d3f4509"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "test-model" do
    url "https://github.com/tensorflow/models/raw/v1.13.0/samples/languages/java/training/model/graph.pb"
    sha256 "147fab50ddc945972818516418942157de5e7053d4b67e7fca0b0ada16733ecb"
  end

  def install
    # Bazel fails if version from .bazelversion doesn't match bazel version, so just delete it
    rm_f ".bazelversion"

    venv = virtualenv_create("#{buildpath}/venv", "python3")
    (resources.map(&:name).to_set - ["test-model"]).each do |r|
      venv.pip_install resource(r)
    end
    ENV["PYTHON_BIN_PATH"] = "#{buildpath}/venv/bin/python"
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
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

    bazel_args =%W[
      --jobs=#{ENV.make_jobs}
      --compilation_mode=opt
      --copt=-march=native
    ]
    targets = %w[
      tensorflow:libtensorflow.so
      tensorflow/tools/benchmark:benchmark_model
      tensorflow/tools/graph_transforms:summarize_graph
      tensorflow/tools/graph_transforms:transform_graph
    ]
    system "bazel", "build", *bazel_args, *targets

    lib.install Dir["bazel-bin/tensorflow/*.so*", "bazel-bin/tensorflow/*.dylib*"]
    (include/"tensorflow/c").install %w[
      tensorflow/c/c_api.h
      tensorflow/c/c_api_experimental.h
      tensorflow/c/tf_attrtype.h
      tensorflow/c/tf_datatype.h
      tensorflow/c/tf_status.h
      tensorflow/c/tf_tensor.h
    ]
    bin.install %w[
      bazel-bin/tensorflow/tools/benchmark/benchmark_model
      bazel-bin/tensorflow/tools/graph_transforms/summarize_graph
      bazel-bin/tensorflow/tools/graph_transforms/transform_graph
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
    system ENV.cc, "-L#{lib}", "-ltensorflow", "-o", "test_tf", "test.c"
    assert_equal version, shell_output("./test_tf")

    resource("test-model").stage(testpath)

    summarize_graph_output = shell_output("#{bin}/summarize_graph --in_graph=#{testpath}/graph.pb 2>&1")
    variables_match = /Found \d+ variables:.+$/.match(summarize_graph_output)
    assert_not_nil variables_match, "Unexpected stdout from summarize_graph for graph.pb (no found variables)"
    variables_names = variables_match[0].scan(/name=([^,]+)/).flatten.sort

    transform_command = %W[
      #{bin}/transform_graph
      --in_graph=#{testpath}/graph.pb
      --out_graph=#{testpath}/graph-new.pb
      --inputs=n/a
      --outputs=n/a
      --transforms="obfuscate_names"
      2>&1
    ].join(" ")
    shell_output(transform_command)

    assert_predicate testpath/"graph-new.pb", :exist?, "transform_graph did not create an output graph"

    new_summarize_graph_output = shell_output("#{bin}/summarize_graph --in_graph=#{testpath}/graph-new.pb 2>&1")
    new_variables_match = /Found \d+ variables:.+$/.match(new_summarize_graph_output)
    assert_not_nil new_variables_match, "Unexpected summarize_graph output for graph-new.pb (no found variables)"
    new_variables_names = new_variables_match[0].scan(/name=([^,]+)/).flatten.sort

    assert_not_equal variables_names, new_variables_names, "transform_graph didn't obfuscate variable names"

    benchmark_model_match = /benchmark_model -- (.+)$/.match(new_summarize_graph_output)
    assert_not_nil benchmark_model_match,
      "Unexpected summarize_graph output for graph-new.pb (no benchmark_model example)"

    benchmark_model_args = benchmark_model_match[1].split(" ")
    benchmark_model_args.delete("--show_flops")

    benchmark_model_command = [
      "#{bin}/benchmark_model",
      "--time_limit=10",
      "--num_threads=1",
      *benchmark_model_args,
      "2>&1",
    ].join(" ")

    assert_includes shell_output(benchmark_model_command),
      "Timings (microseconds):",
      "Unexpected benchmark_model output (no timings)"
  end
end
