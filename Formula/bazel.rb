class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/1.0.0/bazel-1.0.0-dist.zip"
  sha256 "c61daf0b69dd95205c695b2f9022d296d052c727062cfd396d54ffb2154f8cac"

  bottle do
    cellar :any_skip_relocation
    sha256 "df6e66290801867c1609d21d9ef6d2cbf591f9af6b4514aa1fcb5f33838dff62" => :catalina
    sha256 "5b9f050fef3158ff46730f101f26a578a68093b766a31d2fa1e3dfcfe06f8ff8" => :mojave
    sha256 "c74ff8a40009c4dc75b4fcc0a3d416a43b620a104e113c7bbfe73103d0bb1a01" => :high_sierra
    sha256 "6885343d1bab2fd93094a8a4fc07afd6ce2dba3a432409e8c5ebe9cf28cee8e1" => :sierra
  end

  depends_on "python" => :build
  depends_on :java => "1.8"
  depends_on :macos => :yosemite

  def install
    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"

    (buildpath/"sources").install buildpath.children

    cd "sources" do
      system "./compile.sh"
      system "./output/bazel",
             "--output_user_root",
             buildpath/"output_user_root",
             "build",
             "--host_java_toolchain=@bazel_tools//tools/jdk:toolchain_hostjdk8",
             "--java_toolchain=@bazel_tools//tools/jdk:toolchain_hostjdk8",
             "--host_javabase=@bazel_tools//tools/jdk:jdk",
             "--javabase=@bazel_tools//tools/jdk:jdk",
             "scripts:bash_completion"

      bin.install "scripts/packages/bazel.sh" => "bazel"
      (libexec/"bin").install "output/bazel" => "bazel-real"
      bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))

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
           "--host_java_toolchain=@bazel_tools//tools/jdk:toolchain_hostjdk8",
           "--java_toolchain=@bazel_tools//tools/jdk:toolchain_hostjdk8",
           "--host_javabase=@bazel_tools//tools/jdk:jdk",
           "--javabase=@bazel_tools//tools/jdk:jdk",
           "//:bazel-test"
    assert_equal "Hi!\n", pipe_output("bazel-bin/bazel-test")
  end
end
