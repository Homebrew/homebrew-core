class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/0.10.0/bazel-0.10.0-dist.zip"
  sha256 "47e0798caaac4df499bce5fe554a914abd884a855a27085a4473de1d737d9548"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb9e071f36bd5024e3781d227f98639bc2632cb0cc88cb39ac5dcf1d13d2a5ed" => :high_sierra
    sha256 "ce9c9e7c7f98078284505abc234e2b102f8a7293f4c91e4880de020fc5a2162b" => :sierra
    sha256 "45c055a9a7dfaaa3104de980ef749a5c4c2267ba87dc532e85e995fb09b0d31f" => :el_capitan
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
