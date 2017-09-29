class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/0.6.0/bazel-0.6.0-dist.zip"
  sha256 "a0e53728a9541ef87934831f3d05f2ccfdc3b8aeffe3e037be2b92b12400598e"

  bottle do
    cellar :any_skip_relocation
    sha256 "08e1374909896be1519c331c15ceaeca363042232255e1be77dc1ea1f3089061" => :high_sierra
    sha256 "c182ec1062da5552bf048ca55f211a35d1954e0b104fcf3da74b056e2484219d" => :sierra
    sha256 "34606c4f55f9fb95e25a8dd9ab13d2505dd9d0687228ec824de93b7435730d09" => :el_capitan
    sha256 "e44abd01576e56b17859b0bb840f854178b6d975641c1eba082625157b650467" => :yosemite
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
