class Libtensorflow < Formula
  include Language::Python::Virtualenv

  desc "C interface for Google's OS library for Machine Intelligence"
  homepage "https://www.tensorflow.org/"
  url "https://github.com/tensorflow/tensorflow/archive/refs/tags/v2.21.0.tar.gz"
  sha256 "ef3568bb4865d6c1b2564fb5689c19b6b9a5311572cd1f2ff9198636a8520921"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "120736ceb03358fc1f6ca553a337b83588172627bf649504832806e1d3f9ac2f"
    sha256 cellar: :any, arm64_tahoe:       "34100fc36d361127dea8feffca407159ef40669d5b21f8e19825c505cdfafc0c"
    sha256 cellar: :any, arm64_sequoia:     "4f66d7fb898069c20d778c24ab6d107bf4ad922374a6af7d92b5a9c8c5a36bc2"
    sha256 cellar: :any, arm64_linux:       "5caaa8079fc81c3f06cfbf452fa33e01da15dac5eb3016b59b3ee7c5c9982cfa"
    sha256 cellar: :any, x86_64_linux:      "fb113a6e5290eab1c62fe1b10fefb26608d42e1a0dcb388eba9d6ae75a6aa0cd"
  end

  depends_on "bazel@7" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.13" => :build # Python 3.14 support: https://github.com/tensorflow/tensorflow/issues/102890
  depends_on "openblas"

  on_macos do
    depends_on "gnu-getopt" => :build
  end

  on_linux do
    depends_on "patchelf" => :build
    depends_on "vim" => :build # for xxd, TODO: try to remove in next release
  end

  pypi_packages package_name:   "",
                extra_packages: "numpy"

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/13/01/11703282db468b85f6f7b8c7f22d058de5970d5c7e60a3a8aaa313c3de36/numpy-2.5.3.tar.gz"
    sha256 "df2d5874ff183595a4ba404edd04f6bd9b5505c1d7708573f6a6c17489a67563"
  end

  resource "homebrew-test-model", :test do
    url "https://github.com/tensorflow/models/raw/v1.13.0/samples/languages/java/training/model/graph.pb"
    sha256 "147fab50ddc945972818516418942157de5e7053d4b67e7fca0b0ada16733ecb"
  end

  def install
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources.reject(&:test?)

    optflag = ENV["HOMEBREW_OPTFLAGS"].presence
    optflag ||= if Hardware::CPU.arm? && OS.mac?
      "-mcpu=apple-m1"
    else
      "-march=native"
    end
    ENV["CC_OPT_FLAGS"] = optflag
    ENV["PYTHON_BIN_PATH"] = venv.root/"bin/python"
    ENV["USE_DEFAULT_PYTHON_LIB_PATH"] = "1"
    ENV["TF_NEED_CUDA"] = "0"
    ENV["TF_NEED_MPI"] = "0"
    ENV["TF_NEED_ROCM"] = "0"
    ENV["TF_NEED_CLANG"] = "0" if OS.linux?
    ENV["TF_DOWNLOAD_CLANG"] = "0"
    ENV["TF_SET_ANDROID_WORKSPACE"] = "0"
    ENV["TF_CONFIGURE_IOS"] = "0"

    # Build with brew Bazel rather than Bazelisk downloading it
    rm ".bazelversion"

    # `//xla/tsl/mkl:onednn` alias resolves to dummy on macOS; reference @onednn directly.
    inreplace "third_party/xla/xla/tsl/framework/contraction/BUILD",
              '"//conditions:default": ["//xla/tsl/mkl:onednn"],',
              '"//conditions:default": ["@onednn//:mkl_dnn"],'

    # Bump rules_ml_toolchain to bundle libxml2/libz/liblzma with LLVM 18 aarch64 toolchain.
    # PR refs: https://github.com/google-ml-infra/rules_ml_toolchain/pull/209
    #          https://github.com/google-ml-infra/rules_ml_toolchain/pull/220
    inreplace "WORKSPACE" do |s|
      s.gsub! "54c1a357f71f611efdb4891ebd4bcbe4aeb6dfa7e473f14fd7ecad5062096616",
              "415ffc746fad15c3c847c993b4a1b898bdf85811c51bc2aeb5258ce4418c59fd"
      s.gsub! "rules_ml_toolchain-d8cb9c2c168cd64000eaa6eda0781a9615a26ffe",
              "rules_ml_toolchain-88c2e7a7ca80c164bddaeea8abdf802cafd7009b"
      s.gsub! "d8cb9c2c168cd64000eaa6eda0781a9615a26ffe.tar.gz",
              "88c2e7a7ca80c164bddaeea8abdf802cafd7009b.tar.gz"
    end

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
    # Bazel's Apple toolchain passes an explicit `-target` whose macOS version defaults
    # to the SDK version, so bottles would carry the builder's SDK as their minimum OS.
    # Pin it so LC_BUILD_VERSION matches the macOS the bottle is built for.
    bazel_args << "--macos_minimum_os=#{MacOS.version}" if OS.mac?
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
    system "bazel", "build", *bazel_args, *targets

    bin.install %w[
      bazel-bin/tensorflow/tools/benchmark/benchmark_model
      bazel-bin/tensorflow/tools/graph_transforms/summarize_graph
      bazel-bin/tensorflow/tools/graph_transforms/transform_graph
    ]
    libtensorflow_deps.each do |dep|
      system "tar", "-C", prefix, "-xf", "bazel-bin/tensorflow/tools/lib_package/#{dep}.tar"
    end

    ENV.prepend_path "PATH", formula_opt_prefix("gnu-getopt")/"bin" if OS.mac?
    system "tensorflow/c/generate-pc.sh", "--prefix", opt_prefix, "--version", version.to_s
    (lib/"pkgconfig").install "tensorflow.pc"
  end

  test do
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
