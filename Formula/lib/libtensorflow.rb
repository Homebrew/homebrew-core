class Libtensorflow < Formula
  desc "C interface for Google's OS library for Machine Intelligence"
  homepage "https://www.tensorflow.org/"
  url "https://github.com/tensorflow/tensorflow/archive/refs/tags/v2.16.1.tar.gz"
  sha256 "c729e56efc945c6df08efe5c9f5b8b89329c7c91b8f40ad2bb3e13900bd4876d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "80aafb14349d536de3af8e0480ad1c5bc6bdcb6d25f7fe50aebd4e02d7c2a636"
    sha256 cellar: :any,                 arm64_ventura:  "62c1b3dd69e265dc704c78f2539f6b8dc708b229baad1094617e197a709daee5"
    sha256 cellar: :any,                 arm64_monterey: "8fc3d4a3ac2cda3a7eccbf294457b590da79fa65d50321b9280dd5bf6efe824f"
    sha256 cellar: :any,                 sonoma:         "78ee9d092551735d76204c894837916d7c1fb9d3fce13b272f362f1b2f9825fd"
    sha256 cellar: :any,                 ventura:        "9392558546076cd4f335c2921fa189a9d22071ee9fa7486dbab8750dbd014785"
    sha256 cellar: :any,                 monterey:       "c720eed4ca3dd12c78a1346f5aaf1057e898e945706c94c8f18f1316ccc47220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7157828852a7166ec6b5b0e66c7153a503f8cfd667773b6bf26ab511e8b8e83d"
  end

  depends_on "bazelisk" => :build
  depends_on "numpy" => :build
  depends_on "python@3.12" => :build

  on_macos do
    depends_on "gnu-getopt" => :build
  end

  resource "homebrew-test-model" do
    url "https://github.com/tensorflow/models/raw/v1.13.0/samples/languages/java/training/model/graph.pb"
    sha256 "147fab50ddc945972818516418942157de5e7053d4b67e7fca0b0ada16733ecb"
  end

  def install
    python3 = "python3.12"
    optflag = if Hardware::CPU.arm? && OS.mac?
      "-mcpu=apple-m1"
    elsif build.bottle?
      "-march=#{Hardware.oldest_cpu}"
    else
      "-march=native"
    end
    ENV["CC_OPT_FLAGS"] = optflag
    ENV["PYTHON_BIN_PATH"] = which(python3)
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
    ENV["TF_NEED_CLANG"] = "0" if OS.linux?
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
      pyver = Language::Python.major_minor_version python3
      env_path = "#{Formula["python@#{pyver}"].opt_libexec}/bin:#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin"
      bazel_args += %W[
        --action_env=PATH=#{env_path}
        --host_action_env=PATH=#{env_path}
      ]
    end
    targets = %w[
      //tensorflow/tools/lib_package:libtensorflow
      //tensorflow/tools/benchmark:benchmark_model
      //tensorflow/tools/graph_transforms:summarize_graph
      //tensorflow/tools/graph_transforms:transform_graph
    ]
    system Formula["bazelisk"].opt_bin/"bazelisk", "build", *bazel_args, *targets

    bin.install %w[
      bazel-bin/tensorflow/tools/benchmark/benchmark_model
      bazel-bin/tensorflow/tools/graph_transforms/summarize_graph
      bazel-bin/tensorflow/tools/graph_transforms/transform_graph
    ]
    system "tar", "-C", prefix, "-xzf", "bazel-bin/tensorflow/tools/lib_package/libtensorflow.tar.gz"

    ENV.prepend_path "PATH", Formula["gnu-getopt"].opt_prefix/"bin" if OS.mac?
    system "tensorflow/c/generate-pc.sh", "--prefix", prefix, "--version", version.to_s
    (lib/"pkgconfig").install "tensorflow.pc"
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
