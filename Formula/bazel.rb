class Bazel < Formula
  desc "Google's own build tool"
  homepage "http://www.bazel.io/"
  url "https://github.com/bazelbuild/bazel/archive/0.3.1.tar.gz"
  sha256 "52beafc9d78fc315115226f31425e21df1714d96c7dfcdeeb02306e2fe028dd8"
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
    # Force Bazel to put all temporary file in the homebrew cache
    ENV["BAZEL_WRKDIR"] = "#{HOMEBREW_CACHE}/bazel-workdir"

    system "./compile.sh"
    system "./output/bazel", "build", "scripts:bash_completion"

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

    system "#{bin}/bazel", "build", "//:bazel-test"
    system "bazel-bin/bazel-test"
  end
end
