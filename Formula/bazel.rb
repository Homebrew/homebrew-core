class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/0.27.0/bazel-0.27.0-dist.zip"
  sha256 "c3080d3b959ac08502ad5c84a51608c291accb1481baad88a628bbf79b30c67a"

  bottle do
    cellar :any_skip_relocation
    sha256 "53f002d3a285f67e1516b7e1d918ff4526564f23c331075cc53dd18eb756b172" => :mojave
    sha256 "35e1bb09589cf11bc0d851eed596d31ec13c53baf68ac9d43892fa81141127d1" => :high_sierra
    sha256 "682fc8a7f96414dc91eaa8940dda7411ece61d4f72da509bcbec7878891f5d1e" => :sierra
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
