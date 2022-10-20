class Libtensorflow < Formula
  desc "C interface for Google's OS library for Machine Intelligence"
  homepage "https://www.tensorflow.org/"
  url "https://github.com/tensorflow/tensorflow/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "b5a1bb04c84b6fe1538377e5a1f649bb5d5f0b2e3625a3c526ff3a8af88633e8"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "09bf63a4fcdf438a0c5d0ee89b66db15fe959ebc260b37a48f9bdb36c6cb8fa3"
    sha256 cellar: :any,                 arm64_big_sur:  "0b71f38331612569264154e8d27bf087c12d0c29aedc770b44addca2974ba00e"
    sha256 cellar: :any,                 monterey:       "b4a70f6962773b161f4e7ce0fe6898f25cf64a1654909974a4136a71ae091342"
    sha256 cellar: :any,                 big_sur:        "89cca8ee1e8f5838dbcf75482345b9d3e19f2f406a22a29836f4e0669aa580cf"
    sha256 cellar: :any,                 catalina:       "d1f7461958f9210b974d736837f3de2b8cc35a640590557e49a8a6d154f1d4ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61a0964d730c01ba2608c40f95a04c9159d76e08821ebc4c24ec60d80c8feba0"
  end

  depends_on "bazelisk" => :build
  depends_on "numpy" => :build
  depends_on "python@3.10" => :build

  resource "homebrew-test-model" do
    url "https://github.com/tensorflow/models/raw/v1.13.0/samples/languages/java/training/model/graph.pb"
    sha256 "147fab50ddc945972818516418942157de5e7053d4b67e7fca0b0ada16733ecb"
  end

  def install
    optflag = if Hardware::CPU.arm? && OS.mac?
      "-mcpu=apple-m1"
    elsif build.bottle?
      "-march=#{Hardware.oldest_cpu}"
    else
      "-march=native"
    end
    ENV["CC_OPT_FLAGS"] = optflag
    ENV["PYTHON_BIN_PATH"] = which("python3.10")
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

    bazel_args = %W[
      --jobs=#{ENV.make_jobs}
      --compilation_mode=opt
      --copt=#{optflag}
      --linkopt=-Wl,-rpath,#{rpath}
      --verbose_failures
    ]
    if OS.linux?
      env_path = "#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin"
      bazel_args += %W[
        --action_env=PATH=#{env_path}
        --host_action_env=PATH=#{env_path}
      ]
    end
    targets = %w[
      tensorflow:libtensorflow.so
      tensorflow:install_headers
      tensorflow/tools/benchmark:benchmark_model
      tensorflow/tools/graph_transforms:summarize_graph
      tensorflow/tools/graph_transforms:transform_graph
    ]
    system Formula["bazelisk"].opt_bin/"bazelisk", "build", *bazel_args, *targets

    lib.install Dir["bazel-bin/tensorflow/*.so*", "bazel-bin/tensorflow/*.dylib*"]
    include.install "bazel-bin/tensorflow/include/tensorflow"
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
    system ENV.cc, "test.c", "-L#{lib}", "-ltensorflow", "-o", "test_tf"
    assert_equal version, shell_output("./test_tf")

    resource("homebrew-test-model").stage(testpath)

    summarize_graph_output = shell_output("#{bin}/summarize_graph --in_graph=#{testpath}/graph.pb 2>&1")
    variables_match = /Found \d+ variables:.+$/.match(summarize_graph_output)
    refute_nil variables_match, "Unexpected stdout from summarize_graph for graph.pb (no found variables)"
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
    refute_nil new_variables_match, "Unexpected summarize_graph output for graph-new.pb (no found variables)"
    new_variables_names = new_variables_match[0].scan(/name=([^,]+)/).flatten.sort

    refute_equal variables_names, new_variables_names, "transform_graph didn't obfuscate variable names"

    benchmark_model_match = /benchmark_model -- (.+)$/.match(new_summarize_graph_output)
    refute_nil benchmark_model_match,
      "Unexpected summarize_graph output for graph-new.pb (no benchmark_model example)"

    benchmark_model_args = benchmark_model_match[1].split
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
