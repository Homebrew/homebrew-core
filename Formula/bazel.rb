class Bazel < Formula
  desc "Google's own build tool"
  homepage "http://bazel.io/"
  url "https://github.com/bazelbuild/bazel/archive/0.2.2b.tar.gz"
  version "0.2.2b"
  sha256 "0f5ebce329e4aa3c36e428f8994c72bc896f491e0d45aa55f5cc40834b4839f2"

  bottle do
    cellar :any_skip_relocation
    sha256 "33e512a0e8f97f6fa95e3134317cd385f3447ab83b90fc09e31db52b0c646d05" => :el_capitan
    sha256 "7b5e0bd6824200bbbb0943205c6c5021b5448476f7923b9aaf6e3542ab937206" => :yosemite
  end

  depends_on :java => "1.8+"
  depends_on :macos => :yosemite

  def install
    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # Bazel has it owns sandbox, ensure it works.
    ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"]
    ENV["CC"] = `xcrun -f #{ENV["CC"]}`.strip

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
