class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/0.5.2/bazel-0.5.2-dist.zip"
  sha256 "2418c619bdd44257a170b85b9d2ecb75def29e751b725e27186468ada2e009ea"

  bottle do
    cellar :any_skip_relocation
    sha256 "de2b51700e26ec197abdd96d79f5fe8c7edcbddf11b7173fb7346e4daf28f116" => :sierra
    sha256 "bbddd1bedcfab9bd45a5cf859a68986f81a7ae5b323acf6fb5c38aaf90c6471a" => :el_capitan
    sha256 "f9bcf23cbfec915780b89b8e9cdb75e69c287e8522cda6e5091605c7b89a7881" => :yosemite
  end

  depends_on :java => "1.8+"
  depends_on :macos => :yosemite

  # Upstream PR from 27 Jun 2017 "Fix build failure with old OS X mktemp"
  # See https://github.com/bazelbuild/bazel/issues/3279
  patch do
    url "https://github.com/bazelbuild/bazel/pull/3281.patch?full_index=1"
    sha256 "2584b81dfe0115281ece11a3dd5dbfe07233700fc904c81a58c0bcaf0f48c275"
  end

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
