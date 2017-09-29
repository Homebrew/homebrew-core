class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/0.6.0/bazel-0.6.0-dist.zip"
  sha256 "a0e53728a9541ef87934831f3d05f2ccfdc3b8aeffe3e037be2b92b12400598e"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ab56b0359e93105648fe3048792d5ff0aaf03dfa23887a3f1adc207b17dad74" => :high_sierra
    sha256 "6a506a5a054ae45b3ef59586921c358ff1db6f2c0e5fe2bfa5127778d129debd" => :sierra
    sha256 "27808841dded7c5b4b8ebf9fa61fdc300b03c734de1300680ff2c239a5fa4500" => :el_capitan
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
