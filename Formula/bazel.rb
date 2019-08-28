class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/0.29.0/bazel-0.29.0-dist.zip"
  sha256 "01cb6f2e808bd016cf0e217e12373c9efb808123e58b37885be8364458d3a40a"

  bottle do
    cellar :any_skip_relocation
    sha256 "03350b0c46b0b4b16689e05a1c3b8eaf380867bcdce97fb2165cfd0cedc10d59" => :mojave
    sha256 "07a2460201ea9a968beeea201e3697e587eb867fc67832a042b3f652d6325022" => :high_sierra
    sha256 "12a09d707b1a8b0467001ae118be668dbbba21e9c3efbd8263945dd5e29c45e6" => :sierra
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
