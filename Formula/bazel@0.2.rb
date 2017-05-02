class BazelAT02 < Formula
  desc "Google's own build tool"
  homepage "https://bazel.io/"
  url "https://github.com/bazelbuild/bazel/archive/0.2.3.tar.gz"
  sha256 "37fd2d49c57df171b704bf82c94e7bf954d94748e2a8621c5456c5c9d5f2c845"
  revision 1
  head "https://github.com/bazelbuild/bazel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5e6c648edbec511c3601fadeb844153353a849d1a98477abf35acaa9811653b" => :sierra
    sha256 "817f8e2b93a256d85e333e6891a16b5cd03eb844ccaf1a12a31f84aee977ba22" => :el_capitan
    sha256 "fc763b0aae8a06c127fe03dd4ad684e5f817e8a5037f682248e2c65ee52f4e7e" => :yosemite
  end

  keg_only :versioned_formula

  depends_on :java => "1.8+"
  depends_on :macos => :yosemite

  if MacOS.version >= :sierra
    # Use nanosleep(2) instead of poll(2) to sleep.
    patch do
      url "https://github.com/bazelbuild/bazel/commit/fefd232.patch"
      sha256 "1f668d35ed81ce4c3d12c0011b1aaaabbf8ee65f633733cd96b77e57e79f8536"
    end
  end

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
