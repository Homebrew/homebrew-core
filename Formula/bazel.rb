class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/0.5.2/bazel-0.5.2-dist.zip"
  sha256 "2418c619bdd44257a170b85b9d2ecb75def29e751b725e27186468ada2e009ea"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6ae5fa10df55134b0f4aea40a0b91adcb960631662450cffc86b6bf384643a3" => :sierra
    sha256 "f027608fda27d02eb30241dda3768d298ddd5ee30319749179da6ffcd4d88934" => :el_capitan
    sha256 "381fc2e14325cfb7f16395d519c2ba5c6404888ef8600ec76677aabe16029e15" => :yosemite
  end

  depends_on :java => "1.8+"
  depends_on :macos => :yosemite

  # Upstream PR from 27 Jun 2017 "Fix build failure with old OS X mktemp"
  # See https://github.com/bazelbuild/bazel/issues/3279
  patch do
    url "https://github.com/bazelbuild/bazel/pull/3281.patch"
    sha256 "2d5c0e7d33c472ceda7fe33b78da6869bddb0a5e53e5c487346e1b69fa6f22b8"
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
