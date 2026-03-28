class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/9.0.1/bazel-9.0.1-dist.zip"
  sha256 "3f336b4510a8210f954fa3a7d6cfbd271b6f9d639732fdc11c000b6fbfca3fbe"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ace3a0b869e8997cec1d88129333930ae5062ac00baf681ef4a4c696cfadef7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ace3a0b869e8997cec1d88129333930ae5062ac00baf681ef4a4c696cfadef7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "369104e26611c27f9cef1aa183d1d672502fd1982f41df55ceacd4c085648d1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8fd2561569052e9ee80d8f1c081563371e33a6686b8bb896ce5a31e13321fc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f5505c7260a0d795604f3b096b47577e800dcec1957c5011ffd2fa85a570aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4053dd76ddc6ba020938ca5b5e5f7884366bf9f18c2ff92f94b01130ca74215c"
  end

  depends_on "openjdk@21"

  uses_from_macos "python" => :build
  uses_from_macos "unzip"
  uses_from_macos "zip"

  on_linux do
    # We use a workaround to prevent modification of the `bazel-real` binary
    # but this means brew cannot rewrite paths for non-default prefix
    pour_bottle? only_if: :default_prefix

    on_arm do
      # Workaround for "/usr/bin/ld.gold: internal error in try_fix_erratum_843419_optimized"
      # Issue ref: https://sourceware.org/bugzilla/show_bug.cgi?id=31182
      depends_on "lld" => :build
    end
  end

  conflicts_with "bazelisk", because: "Bazelisk replaces the bazel binary"

  def bazel_real
    libexec/"bin/bazel-real"
  end

  def install
    java_home_env = Language::Java.java_home_env("21")

    ENV["EMBED_LABEL"] = "#{version} #{tap.user}"

    # Force Bazel to use brewed OpenJDK and PATH
    # Ignore Xlint and external warnings. See https://github.com/bazelbuild/bazel/blob/726d5b3d31a57ee13e1a3cdc4607888368409bd1/.bazelrc#L61-L63
    extra_bazel_args = %W[
      --tool_java_runtime_version=local_jdk
      --action_env=PATH
      --host_action_env=PATH
      --isatty=no
      --jobs=#{ENV.make_jobs}
      --per_file_copt=external/.*@-w
      --host_per_file_copt=external/.*@-w
      --javacopt=-Xlint:-removal
      --host_javacopt=-Xlint:-removal
    ]
    ENV.merge! java_home_env.transform_keys(&:to_s)
    # Bazel clears environment variables which breaks superenv shims
    ENV.remove "PATH", "#{Superenv.shims_path}:"

    # Set dynamic linker similar to cc shim so that bottle works on older Linux
    if OS.linux? && build.bottle? && ENV["HOMEBREW_DYNAMIC_LINKER"]
      extra_bazel_args << "--linkopt=-Wl,--dynamic-linker=#{ENV["HOMEBREW_DYNAMIC_LINKER"]}"
    end

    if OS.linux? && Hardware::CPU.arch == :arm64
      extra_bazel_args << "--linkopt=-fuse-ld=lld"
      extra_bazel_args << "--host_linkopt=-fuse-ld=lld"
    end

    ENV["EXTRA_BAZEL_ARGS"] = extra_bazel_args.join(" ")

    system "./compile.sh"

    bin.install "scripts/packages/bazel.sh" => "bazel"
    ln_s bazel_real, bin/"bazel-#{version}"
    (libexec/"bin").install "output/bazel" => "bazel-real"
    bin.env_script_all_files libexec/"bin", java_home_env

    bash_completion.mkpath
    fish_completion.mkpath
    zsh_completion.install "scripts/zsh_completion/_bazel"

    ENV["PYTHONPATH"] = buildpath/"third_party/py/abseil"
    # Genenate shell completions without `bazel build` to avoid recompilation of dependencies
    system "scripts/generate_bash_completion.sh", "--bazel=#{bazel_real}", "--output=#{bash_completion}/bazel"
    system "python3", "scripts/generate_fish_completion.py", "--bazel=#{bazel_real}",
    "--output=#{fish_completion}/bazel.fish"

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

  def post_install
    if File.exist?("#{bazel_real}.gz")
      rm(bazel_real)
      system "gunzip", "#{bazel_real}.gz"
      bazel_real.chmod 0755
    end
  end

  test do
    (testpath/"MODULE.bazel").write <<~STARLARK
      bazel_dep(name = "rules_java", version = "9.5.0")
    STARLARK

    (testpath/"ProjectRunner.java").write <<~JAVA
      public class ProjectRunner {
        public static void main(String args[]) {
          System.out.println("Hi!");
        }
      }
    JAVA

    (testpath/"BUILD").write <<~STARLARK
      load("@rules_java//java:defs.bzl", "java_binary")

      java_binary(
        name = "bazel-test",
        srcs = glob(["*.java"]),
        main_class = "ProjectRunner",
      )
    STARLARK

    system bin/"bazel", "build", "//:bazel-test", "--repo_contents_cache="
    assert_equal "Hi!\n", shell_output("bazel-bin/bazel-test")

    # Verify wrapper script delegation behavior
    (testpath/"tools/bazel").write <<~SHELL
      #!/bin/bash
      echo "stub-wrapper"
      exit 1
    SHELL
    (testpath/"tools/bazel").chmod 0755

    assert_equal "stub-wrapper\n", shell_output("#{bin}/bazel --version", 1)
    assert_match "bazel #{version}", shell_output("#{bin}/bazel-#{version} --version")
  end
end
