class Bazel < Formula
  desc "Google's own build tool"
  homepage "http://www.bazel.io/"
  url "https://github.com/bazelbuild/bazel/archive/0.3.0.tar.gz"
  sha256 "d2309c29781dc4ede79eb652776517ca3c1dff29b58849dc80bdb86031cce3ad"
  head "https://github.com/bazelbuild/bazel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d51899dc3a99c1c5a965006aacabf4a935dfb4d145b1d66df724fc0a35f8807d" => :el_capitan
    sha256 "b2f7b4b77be9111ea8b4b4a9a5058b2e0c2bc015acdb06e72634a7babb6cb583" => :yosemite
  end

  depends_on :java => "1.8+"
  depends_on :macos => :yosemite

  def install
    ENV["EMBED_LABEL"] = "#{version}-homebrew"

    system "./compile.sh"
    system "./output/bazel", "build", "scripts:bash_completion"

    bin.install "output/bazel" => "bazel"
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

    system "#{bin}/bazel", "build", "//:bazel-test"
    system "bazel-bin/bazel-test"
  end
end
