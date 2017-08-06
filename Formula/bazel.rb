class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/0.5.3/bazel-0.5.3-dist.zip"
  sha256 "76b5c5880a0b15f5b91f7d626c5bc3b76ce7e5d21456963c117ab711bf1c5333"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "71607514310a6def0f190362c1ac1fc26f4f667b45fcacd943af49465cab2daf" => :sierra
    sha256 "2074ba5af8294b6e008582535267ad70707ef02e679d43adb6648a32057df2c4" => :el_capitan
    sha256 "7e6ee2064e2abb6f2fd6ec06bc361156a46ac7da61a2f45e8eefe0903c0c7639" => :yosemite
  end

  depends_on :java => "1.8+"
  depends_on :macos => :yosemite

  def install
    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"

    system "./compile.sh"
    system "./output/bazel", "--output_user_root", buildpath/"output_user_root",
           "build", "scripts:bash_completion"

    bin.install "scripts/packages/bazel.sh" => "bazel"
    bin.install "output/bazel" => "bazel-real"
    bash_completion.install "bazel-bin/scripts/bazel-complete.bash"
    zsh_completion.install "scripts/zsh_completion/_bazel"
  end

  test do
    touch testpath/"WORKSPACE"

    (testpath/"ProjectRunner.java").write <<-EOS.undent
      public class ProjectRunner {
        public static void main(String args[]) {
          System.out.println("Hi!");
        }
      }
    EOS

    (testpath/"BUILD").write <<-EOS.undent
      java_binary(
        name = "bazel-test",
        srcs = glob(["*.java"]),
        main_class = "ProjectRunner",
      )
    EOS

    system bin/"bazel", "build", "//:bazel-test"
    system "bazel-bin/bazel-test"
  end
end
