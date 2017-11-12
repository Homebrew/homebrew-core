class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/0.7.0/bazel-0.7.0-dist.zip"
  sha256 "a084a9c5d843e2343bf3f319154a48abe3d35d52feb0ad45dec427a1c4ffc416"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "a64a3d9c81d3c55f4b8bc216c31a73323579a87a5ba9e8b692cfbea8b31917cd" => :high_sierra
    sha256 "31718c991ed0d1b4fe92296e0ccb472b908dccabc1d78b29ccf6e8a2b5b2cf1d" => :sierra
    sha256 "6a6eadd2c6ba3c56b9d592366337775e3933aae70bda18387e464c77f3049aac" => :el_capitan
  end

  depends_on :java => "1.8"
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
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))

    bash_completion.install "bazel-bin/scripts/bazel-complete.bash"
    zsh_completion.install "scripts/zsh_completion/_bazel"
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
