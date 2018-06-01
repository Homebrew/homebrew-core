class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/0.14.0/bazel-0.14.0-dist.zip"
  sha256 "259627de8b9d415cc80904523facf3d50e6e8e68448ab968eb1c9cb8ca1ef843"

  bottle do
    cellar :any_skip_relocation
    sha256 "c7b2617add5c3c9d1a94cd796315d7938daa2b8f59978d395437250cbabec90d" => :high_sierra
    sha256 "c3cbbd84f1180b20ea36658adc09c2dbd1949e2379a9c6b65a49890d9f56b069" => :sierra
    sha256 "8831af92d4b61054842ed4d39e1383c08d83dbd9ffa6bc3536dda039a5826904" => :el_capitan
  end

  depends_on :java => "1.8"
  depends_on :macos => :yosemite

  def install
    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"

    (buildpath/"sources").install buildpath.children

    cd "sources" do
      system "./compile.sh"
      system "./output/bazel", "--output_user_root",
             buildpath/"output_user_root", "build", "scripts:bash_completion"

      bin.install "scripts/packages/bazel.sh" => "bazel"
      bin.install "output/bazel" => "bazel-real"
      bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))

      bash_completion.install "bazel-bin/scripts/bazel-complete.bash"
      zsh_completion.install "scripts/zsh_completion/_bazel"

      prefix.install_metafiles
    end
  end

  test do
    touch testpath/"WORKSPACE"

    (testpath/"ProjectRunner.java").write <<~EOS
      public class ProjectRunner {
        public static void main(String args[]) {
          System.out.println("Hi!");
        }
      }
    EOS

    (testpath/"BUILD").write <<~EOS
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
