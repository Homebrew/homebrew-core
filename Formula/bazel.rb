class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/0.5.3/bazel-0.5.3-dist.zip"
  sha256 "76b5c5880a0b15f5b91f7d626c5bc3b76ce7e5d21456963c117ab711bf1c5333"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "7437094497afb5b9d842690cf9f01c254265c344603fff43f7560f064914ebbc" => :sierra
    sha256 "6155a251b0b571fc2e3a9d5293fc5696eaa0cd2df4ef751a334f04c4ce378d0f" => :el_capitan
    sha256 "ccdfccb0373c11b81dd67c04fe85e0b1b78c828f36108b83565df26c059b5aed" => :yosemite
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
