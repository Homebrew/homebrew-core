class BazelAT02 < Formula
  desc "Google's own build tool"
  homepage "https://bazel.io/"
  url "https://github.com/bazelbuild/bazel/archive/0.2.3.tar.gz"
  sha256 "37fd2d49c57df171b704bf82c94e7bf954d94748e2a8621c5456c5c9d5f2c845"
  head "https://github.com/bazelbuild/bazel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3d24665d4e81d9b647bc68a55c8692a2a74db2269c602306aec4c371534180ae" => :sierra
    sha256 "9fedb09a8bf76ff6d447f60ff0c6f3e4e904c38b501b42030ec1c9eb68f7851b" => :el_capitan
    sha256 "06fda3195453ef6a2d98adcfbafb28f186dc690697e7855fdb029fab2fadae0f" => :yosemite
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
