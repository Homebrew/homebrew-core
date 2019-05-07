class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/0.25.1/bazel-0.25.1-dist.zip"
  sha256 "a52bb31aeb1f821e649d25ef48023cfb54a12887aff875c6349ebcac36c2f056"

  bottle do
    cellar :any_skip_relocation
    sha256 "c41a6ebf193db0792578d24a6bd9b44cba0a71de1dcccf56e28b39998a283375" => :mojave
    sha256 "7d6622f6a78000340b1b6c453935530f384effa90ff470b72d65217c07987508" => :high_sierra
    sha256 "eb68775e4df7203a293b8289f13035caf10ac25d6fa3ebf355a572f775ac250a" => :sierra
  end

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
