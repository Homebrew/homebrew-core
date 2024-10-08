class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/7.3.2/bazel-7.3.2-dist.zip"
  sha256 "8c24490a6445b00eb76a04adbb0172f5c51b1edbaeeef91ff7f3c7e86c7921ff"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdfa8d015e39b2e2e2134326773b875ca578718de5e3c84b5d7cfdd75f45df5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e87c96e7f784f3df1ffcf62a43023aa3f4bc8029502f10aa29ce73dd827f468"
    sha256 cellar: :any_skip_relocation, sonoma:        "740275d31fa20af8483395a2ef0687845b1f56c10d38ff56a6bf8be2d32b9e20"
    sha256 cellar: :any_skip_relocation, ventura:       "0d37decf3db2a88e4b809c658390ed686af07f3902c226c6a54b24e9d7935671"
  end

  depends_on "python@3.12" => :build
  depends_on "openjdk@21"

  uses_from_macos "unzip"
  uses_from_macos "zip"

  conflicts_with "bazelisk", because: "Bazelisk replaces the bazel binary"

  def install
    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"
    # Force Bazel to use openjdk@21
    ENV["EXTRA_BAZEL_ARGS"] = "--tool_java_runtime_version=local_jdk"
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    # Force Bazel to use Homebrew python
    ENV.prepend_path "PATH", Formula["python@3.12"].opt_libexec/"bin"

    # Bazel clears environment variables other than PATH during build, which
    # breaks Homebrew's shim scripts that need HOMEBREW_* variables.
    # Bazel's build also resolves the realpath of executables like `cc`,
    # which breaks Homebrew's shim scripts that expect symlink paths.
    #
    # The workaround here is to disable the shim for C/C++ compilers.
    ENV["CC"] = "/usr/bin/cc"
    ENV["CXX"] = "/usr/bin/c++" if OS.linux?

    (buildpath/"sources").install buildpath.children

    cd "sources" do
      system "./compile.sh"
      system "./output/bazel", "--output_user_root",
                               buildpath/"output_user_root",
                               "build",
                               "scripts:bash_completion",
                               "scripts:fish_completion"

      bin.install "scripts/packages/bazel.sh" => "bazel"
      ln_s libexec/"bin/bazel-real", bin/"bazel-#{version}"
      (libexec/"bin").install "output/bazel" => "bazel-real"
      bin.env_script_all_files libexec/"bin", Language::Java.java_home_env("21")

      bash_completion.install "bazel-bin/scripts/bazel-complete.bash"
      zsh_completion.install "scripts/zsh_completion/_bazel"
      fish_completion.install "bazel-bin/scripts/bazel.fish"
    end
  end

  test do
    touch testpath/"WORKSPACE"

    (testpath/"ProjectRunner.java").write <<~EOS
      public class ProjectRunner {
        public static void main(String args[]) {
          System.out.println("Hi!");
        }
      }
    EOS

    (testpath/"BUILD").write <<~EOS
      java_binary(
        name = "bazel-test",
        srcs = glob(["*.java"]),
        main_class = "ProjectRunner",
      )
    EOS

    system bin/"bazel", "build", "//:bazel-test"
    assert_equal "Hi!\n", pipe_output("bazel-bin/bazel-test")

    # Verify that `bazel` invokes Bazel's wrapper script, which delegates to
    # project-specific `tools/bazel` if present. Invoking `bazel-VERSION`
    # bypasses this behavior.
    (testpath/"tools"/"bazel").write <<~EOS
      #!/bin/bash
      echo "stub-wrapper"
      exit 1
    EOS
    (testpath/"tools/bazel").chmod 0755

    assert_equal "stub-wrapper\n", shell_output("#{bin}/bazel --version", 1)
    assert_equal "bazel #{version}-homebrew\n", shell_output("#{bin}/bazel-#{version} --version")
  end
end
