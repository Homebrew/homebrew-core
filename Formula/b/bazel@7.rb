class BazelAT7 < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/7.7.2/bazel-7.7.2-dist.zip"
  sha256 "f40c88b52da292746b6ccf742a0e3f0897a7e4ac24d0143b860f1857f220d5ec"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(7(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a856341f521cc232736f31476370f9af63e5508e41f0163af696f2acc3821ad0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c436f45190502bca9761f1b8efd9159e4478516559d91354ea02d3d6000efc25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2e27d2845a972ccbdcb40abd1cbd30c1121dac049c3ace3c7f45d11f036cda8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d21460df11866ec48ecccddd55290b38e86eb09eab022abc72d226e10aed0597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ef94d9ceef72abc98a895670f0efa3c86037f817872731bb392e26233e92beff"
  end

  keg_only :versioned_formula

  # https://bazel.build/release#support-matrix
  deprecate! date: "2027-01-01", because: :unsupported
  disable! date: "2028-01-01", because: :unsupported

  depends_on "openjdk@21"

  uses_from_macos "python" => :build
  uses_from_macos "unzip"
  uses_from_macos "zip"

  on_linux do
    # We use a workaround to prevent modification of the `bazel-real` binary
    # but this means brew cannot rewrite paths for non-default prefix
    pour_bottle? only_if: :default_prefix
  end

  def bazel_real
    libexec/"bin/bazel-real"
  end

  def install
    java_home_env = Language::Java.java_home_env("21")

    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # https://github.com/bazelbuild/bazel/issues/27401
    ENV["BAZEL_DEV_VERSION_OVERRIDE"] = ENV["EMBED_LABEL"]
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"
    # Force Bazel to use brew OpenJDK
    extra_bazel_args = ["--tool_java_runtime_version=local_jdk"]
    if OS.mac?
      # Tools built for the exec configuration only follow `--host_macos_minimum_os`
      extra_bazel_args << "--macos_minimum_os=#{MacOS.version}.0"
      extra_bazel_args << "--host_macos_minimum_os=#{MacOS.version}.0"
      # Apple clang 21 lists `SDKSettings.json` as a dependency, but Bazel 7's toolchain only allows the CLT SDK
      if MacOS::CLT.installed?
        %w[action_env host_action_env repo_env].each do |opt|
          extra_bazel_args << "--#{opt}=SDKROOT=#{MacOS::CLT::PKG_PATH}/SDKs/MacOSX.sdk"
        end
      end
    end
    ENV.merge! java_home_env.transform_keys(&:to_s)
    # Bazel clears environment variables which breaks superenv shims
    ENV.remove "PATH", Superenv.shims_path

    # Set dynamic linker similar to cc shim so that bottle works on older Linux
    if OS.linux? && build.bottle? && ENV["HOMEBREW_DYNAMIC_LINKER"]
      extra_bazel_args << "--linkopt=-Wl,--dynamic-linker=#{ENV["HOMEBREW_DYNAMIC_LINKER"]}"
    end
    ENV["EXTRA_BAZEL_ARGS"] = extra_bazel_args.join(" ")

    (buildpath/"sources").install buildpath.children

    cd "sources" do
      system "./compile.sh"
      system "./output/bazel", "--output_user_root=#{buildpath}/output_user_root",
                               "build",
                               *extra_bazel_args,
                               "scripts:bash_completion",
                               "scripts:fish_completion"

      bin.install "scripts/packages/bazel.sh" => "bazel"
      ln_s bazel_real, bin/"bazel-#{version}"
      (libexec/"bin").install "output/bazel" => "bazel-real"
      bin.env_script_all_files libexec/"bin", java_home_env

      bash_completion.install "bazel-bin/scripts/bazel-complete.bash" => "bazel"
      zsh_completion.install "scripts/zsh_completion/_bazel"
      fish_completion.install "bazel-bin/scripts/bazel.fish"
    end

    # Workaround to avoid breaking the zip-appended `bazel-real` binary.
    # Can remove if brew correctly handles these binaries or if upstream
    # provides an alternative in https://github.com/bazelbuild/bazel/issues/11842
    if OS.linux? && build.bottle?
      Utils::Gzip.compress(bazel_real)
      bazel_real.write <<~SHELL
        #!/bin/bash
        echo 'ERROR: Need to run `brew postinstall #{name}`' >&2
        exit 1
      SHELL
      bazel_real.chmod 0755
    end
  end

  post_install_steps do
    install_gzipped_executable "bin/bazel-real.gz", "bin/bazel-real",
                                  source_base: :libexec, target_base: :libexec
  end

  test do
    touch testpath/"WORKSPACE"

    (testpath/"ProjectRunner.java").write <<~JAVA
      public class ProjectRunner {
        public static void main(String args[]) {
          System.out.println("Hi!");
        }
      }
    JAVA

    (testpath/"BUILD").write <<~STARLARK
      java_binary(
        name = "bazel-test",
        srcs = glob(["*.java"]),
        main_class = "ProjectRunner",
      )
    STARLARK

    system bin/"bazel", "build", "//:bazel-test"
    assert_equal "Hi!\n", shell_output("bazel-bin/bazel-test")

    # Verify that `bazel` invokes Bazel's wrapper script, which delegates to
    # project-specific `tools/bazel` if present. Invoking `bazel-VERSION`
    # bypasses this behavior.
    (testpath/"tools/bazel").write <<~SHELL
      #!/bin/bash
      echo "stub-wrapper"
      exit 1
    SHELL
    (testpath/"tools/bazel").chmod 0755

    assert_equal "stub-wrapper\n", shell_output("#{bin}/bazel --version", 1)
    assert_equal "bazel #{version}-homebrew\n", shell_output("#{bin}/bazel-#{version} --version")
  end
end
