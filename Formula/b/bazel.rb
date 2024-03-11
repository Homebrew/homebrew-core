class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/7.1.0/bazel-7.1.0-dist.zip"
  sha256 "1e20d0c89f7c9d1b4a381a8c586b4a435a96bfc41fbbcf34a2c29494eb3867a1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dabf0e6eab916c01e2a9264a6c32a566df53f58a44a8ef665ed6f849dc496ef7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dabf0e6eab916c01e2a9264a6c32a566df53f58a44a8ef665ed6f849dc496ef7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "552da03ecda450d46f27f74c87454cf79140d281a5a0466d30044fc9b8b44281"
    sha256 cellar: :any_skip_relocation, sonoma:         "aab5f163fb5514fe91aedd32b54dab6959cfe6559ef93b880929c0cf4bc52089"
    sha256 cellar: :any_skip_relocation, ventura:        "aab5f163fb5514fe91aedd32b54dab6959cfe6559ef93b880929c0cf4bc52089"
    sha256 cellar: :any_skip_relocation, monterey:       "ed0f0ed911a8b7d7a731633bc8860bd04d424bc07c6560aab6a67be95214851a"
  end

  depends_on "python@3.12" => :build
  depends_on "openjdk@11"

  uses_from_macos "unzip"
  uses_from_macos "zip"

  conflicts_with "bazelisk", because: "Bazelisk replaces the bazel binary"

  def install
    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"
    # Force Bazel to use openjdk@11
    ENV["EXTRA_BAZEL_ARGS"] = "--host_javabase=@local_jdk//:jdk"
    ENV["JAVA_HOME"] = Language::Java.java_home("11")
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
      bin.env_script_all_files libexec/"bin", Language::Java.java_home_env("11")

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
