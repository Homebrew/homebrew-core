class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://www.bazel.io/"
  head "https://github.com/bazelbuild/bazel.git"

  stable do
    url "https://github.com/bazelbuild/bazel/archive/0.3.2.tar.gz"
    sha256 "9692ac3318a40e8a0530f68bbfc473ae5f6a4a5c0fe08d2f88612ca4d40ba54a"
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8c28efdb500103fc2fe69f5d32b2b433e00345c55c5003cdc53f76e9aec3a22e" => :sierra
    sha256 "9baa84e3f84d5060d39166ff682f7280e93dd173713b83dd5c95c23dda78c942" => :el_capitan
    sha256 "526bcf3e24b646c1f1648d47868654a16e8f566dcf1575034b039f7e17aa91d4" => :yosemite
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
