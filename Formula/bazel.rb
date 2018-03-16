class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/0.11.1/bazel-0.11.1-dist.zip"
  sha256 "e8d762bcc01566fa50952c8028e95cfbe7545a39b8ceb3a0d0d6df33b25b333f"

  bottle do
    cellar :any_skip_relocation
    sha256 "1254786b2b01b471fa7b7db196567ff8a01a4aa53afb1f02fddaa16ae5e4fa61" => :high_sierra
    sha256 "d35179130398f2e638e7268cd918af60de6ce3a88c190b64efc12c2c624e2a16" => :sierra
    sha256 "784d09fcf9e36b3a7fb15bdec5c2535a8d623a051bc93d5201208ca1edcf14cf" => :el_capitan
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
