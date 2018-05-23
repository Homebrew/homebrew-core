class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/0.13.1/bazel-0.13.1-dist.zip"
  sha256 "b0269e75b40d87ff87886e5f3432cbf88f70c96f907ab588e6c21b2922d72db0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8b4d0b540c3e17ae4dfc1eee8ce31d3f31603de971a94f8540159a81d19f3c5" => :high_sierra
    sha256 "478016621923fc7b84f6bf5e7eaed6e1e52727c8c8636bcdca7f681e22a1502b" => :sierra
    sha256 "16eebc137984826045a6409574d6d30c5232808de535d77e16ce3c50df60238e" => :el_capitan
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
