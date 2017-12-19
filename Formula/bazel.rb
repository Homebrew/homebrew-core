class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/0.9.0/bazel-0.9.0-dist.zip"
  sha256 "efb28fed4ffcfaee653e0657f6500fc4cbac61e32104f4208da385676e76312a"

  bottle do
    cellar :any_skip_relocation
    sha256 "35b1c0670208b22810d029c6c68c6311b3c511f8645159f611dca5a65ca27147" => :high_sierra
    sha256 "9901031265cc4c1851e62b1e54f4993b90bd4a071eddeaffb5c7cf07c4031126" => :sierra
    sha256 "54b3b426eefef6a205146bbbfe19bec1c03abe18de0d9c3692c407d32e2b2426" => :el_capitan
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
