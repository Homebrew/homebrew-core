class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/4.0.0/bazel-4.0.0-dist.zip"
  sha256 "d350f80e70654932db252db380d2ec0144a00e86f8d9f2b4c799ffdb48e9cdd1"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ab24050548f7539419bbd310c00c718854e95b2e7d15a74b2c8246588d95480" => :big_sur
    sha256 "65dd008d9d72b82813e4e5530cbf7c853ab0152ef40c8234402fd51e4a597230" => :arm64_big_sur
    sha256 "d12919775ba3cde5a7f42582fd9cf10513145485ac4a60170e44a1dac70e04fe" => :catalina
    sha256 "974514ef8eef4ca3d7d548a28c89335129781db6e65f5ab8795ba5096c4cfae6" => :mojave
  end

  depends_on "python@3.9" => :build
  depends_on "openjdk@11"

  uses_from_macos "zip"

  # Fix compilation on macOS 10.14 Mojave
  # Remove in the next release
  # See https://github.com/bazelbuild/bazel/pull/12882
  patch do
    url "https://github.com/bazelbuild/bazel/commit/092b4c10fa2a2552dc3a98544d637c02ea2865c7.patch?full_index=1"
    sha256 "273cf54bf4c0fe42fe8da959dc76fc1a3e768f3f3d4108bfd280728db022a308"
  end

  def install
    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"
    # Force Bazel to use openjdk@11
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_libexec/"openjdk.jdk/Contents/Home"
    ENV["EXTRA_BAZEL_ARGS"] = "--host_javabase=@local_jdk//:jdk"

    (buildpath/"sources").install buildpath.children

    cd "sources" do
      system "./compile.sh"
      system "./output/bazel",
             "--output_user_root",
             buildpath/"output_user_root",
             "build",
             "scripts:bash_completion"

      bin.install "scripts/packages/bazel.sh" => "bazel"
      ln_s libexec/"bin/bazel-real", bin/"bazel-#{version}"
      (libexec/"bin").install "output/bazel" => "bazel-real"
      bin.env_script_all_files(libexec/"bin",
        JAVA_HOME: Formula["openjdk@11"].opt_libexec/"openjdk.jdk/Contents/Home")

      bash_completion.install "bazel-bin/scripts/bazel-complete.bash"
      zsh_completion.install "scripts/zsh_completion/_bazel"

      prefix.install_metafiles
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

    system bin/"bazel",
           "build",
           "//:bazel-test"
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
