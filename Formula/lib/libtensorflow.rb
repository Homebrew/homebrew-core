class Libtensorflow < Formula
  desc "C interface for Google's OS library for Machine Intelligence"
  homepage "https://www.tensorflow.org/"
  url "https://github.com/tensorflow/tensorflow/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "a640d1f97be316a09301dfc9347e3d929ad4d9a2336e3ca23c32c93b0ff7e5d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8a15daed2bb63f7178d5ae590a2f6790b24a8339c47f95fcb6e47e1a5837866d"
    sha256 cellar: :any,                 arm64_sequoia: "655650a749f31f659213bba3147b8fccd0f3c15f81380e753f41958b41d9fa9f"
    sha256 cellar: :any,                 arm64_sonoma:  "0aa1ef478705d4a5e1148482bc2f0cee12d1448e1fde9a2146349b5988f8a989"
    sha256 cellar: :any,                 sonoma:        "f6a05fbd2c75dcda4be2adf38a1da8a20cce45a7f87bb48c57ddb7101391db50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8307fca51801bf44da97554ca97a0e574ea5838d7e91bc05f45c5f2ed6b88c4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be3f850fea6e58fce4a67eaa74ff884239e8180433eda0ef228eadf696f86739"
  end

  depends_on "bazelisk" => :build
  depends_on "numpy" => :build
  depends_on "python@3.13" => :build # Python 3.14 support: https://github.com/tensorflow/tensorflow/issues/102890

  on_macos do
    depends_on "gnu-getopt" => :build
  end

  def install
    # Workaround to build on Tahoe by using newer apple_support with following commit:
    # https://github.com/bazelbuild/apple_support/commit/44c43c715aa58d16dc713ec0daa0a4373c39245a
    # Issue ref: https://github.com/tensorflow/tensorflow/issues/100434
    inreplace "tensorflow/workspace2.bzl" do |s|
      s.gsub! "/1.18.1/apple_support.1.18.1.tar.gz", "/1.19.0/apple_support.1.19.0.tar.gz"
      s.gsub! '"d71b02d6df0500f43279e22400db6680024c1c439115c57a9a82e9effe199d7b"',
              '"dca96682317cc7112e6fae87332e13a8fefbc232354c2939b11b3e06c09e5949"'
    end

    python3 = "python3.13"
    optflag = ENV["HOMEBREW_OPTFLAGS"].presence
    optflag ||= if Hardware::CPU.arm? && OS.mac?
      "-mcpu=apple-m1"
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

    # Bazel clears environment variables which breaks superenv shims.
    # Bazel already dodges our superenv on macOS by using its own shim.
    ENV.remove "PATH", Superenv.shims_path if OS.linux?

    bazel_args = %W[
      --jobs=#{ENV.make_jobs}
      --compilation_mode=opt
      --copt=#{optflag}
      --linkopt=-Wl,-rpath,#{rpath}
      --verbose_failures
      --config=monolithic
      --repo_env=USE_PYWRAP_RULES=
      --repo_env=ML_WHEEL_TYPE=release
    ]
    # //tensorflow/tools/lib_package:libtensorflow target was removed in 2.20.0.
    # For now, the deps used by original target still exist so use those to build.
    # https://github.com/tensorflow/tensorflow/commit/724f36e00941ad3abf3c32209adc2ee186602b70
    libtensorflow_deps = %w[
      cheaders
      clib
      clicenses
      eager_cheaders
    ]
    targets = %w[
      //tensorflow/tools/benchmark:benchmark_model
      //tensorflow/tools/graph_transforms:summarize_graph
      //tensorflow/tools/graph_transforms:transform_graph
    ] + libtensorflow_deps.map { |dep| "//tensorflow/tools/lib_package:#{dep}" }
    system Formula["bazelisk"].opt_bin/"bazelisk", "build", *bazel_args, *targets

    bin.install %w[
      bazel-bin/tensorflow/tools/benchmark/benchmark_model
      bazel-bin/tensorflow/tools/graph_transforms/summarize_graph
      bazel-bin/tensorflow/tools/graph_transforms/transform_graph
    ]
    libtensorflow_deps.each do |dep|
      system "tar", "-C", prefix, "-xf", "bazel-bin/tensorflow/tools/lib_package/#{dep}.tar"
    end

    ENV.prepend_path "PATH", Formula["gnu-getopt"].opt_prefix/"bin" if OS.mac?
    system "tensorflow/c/generate-pc.sh", "--prefix", opt_prefix, "--version", version.to_s
    (lib/"pkgconfig").install "tensorflow.pc"
  end

  test do
    resource "homebrew-test-model" do
      url "https://github.com/tensorflow/models/raw/v1.13.0/samples/languages/java/training/model/graph.pb"
      sha256 "147fab50ddc945972818516418942157de5e7053d4b67e7fca0b0ada16733ecb"
    end

    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <tensorflow/c/c_api.h>
      int main() {
        printf("%s", TF_Version());
      }
    C

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

    assert_path_exists testpath/"graph-new.pb", "transform_graph did not create an output graph"

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
