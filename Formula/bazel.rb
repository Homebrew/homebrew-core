class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/0.6.1/bazel-0.6.1-dist.zip"
  sha256 "dada1f60a512789747011184b2767d2b44136ef3b036d86947f1896d200d2ba7"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4e0b6d2a060d8119c9cb28562db3298719df466c79e05dce57847eaeb93ac8f" => :high_sierra
    sha256 "680be93f83faf8dad4c54992b50e2092873db200249ebdc5daf75c44167bdebb" => :sierra
    sha256 "e9acaaaa8f9d1ab3918519ec467fc1df45cb5bd45708404503143bf610597202" => :el_capitan
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
