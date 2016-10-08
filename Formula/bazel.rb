class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://www.bazel.io/"
  head "https://github.com/bazelbuild/bazel.git"
  url "https://github.com/bazelbuild/bazel/archive/0.3.2.tar.gz"
  sha256 "9692ac3318a40e8a0530f68bbfc473ae5f6a4a5c0fe08d2f88612ca4d40ba54a"

  bottle do
    cellar :any_skip_relocation
    sha256 "7407bba2c724555ee20a78ba658d537bfc3858f8e7e3e94e8a23649b4c356795" => :sierra
    sha256 "1951bee16f4d764d4a80a7802f20336fc9e5086be3d95ea529441aaddc44c44d" => :el_capitan
    sha256 "d60b2137ba014b5a44d62fd2649f5a356f3f2fffad35809afad89944804de79a" => :yosemite
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
