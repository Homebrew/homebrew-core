class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/3.7.2/bazel-3.7.2-dist.zip"
  sha256 "de255bb42163a915312df9f4b86e5b874b46d9e8d4b72604b5123c3a845ed9b1"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6103cfebc83a5869dd906b360256a39bd12d5ee9c939877a0632d2e370f5a429" => :big_sur
    sha256 "411a91d29c4fb32cc3c928fe19960159010f4b5691e956b2ab390e57a60abc96" => :catalina
    sha256 "dc0825575b331e1048d1619e9a577c3548bbc07508cbe3fd82c02f4ff0446143" => :mojave
  end

  depends_on "python@3.9" => :build
  depends_on "openjdk@11"

  uses_from_macos "zip"

  def install
    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"
    # Force Bazel to use openjdk@11
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_libexec/"openjdk.jdk/Contents/Home"
    ENV["EXTRA_BAZEL_ARGS"] = "--host_javabase=@local_jdk//:jdk"

    (buildpath/"sources").install buildpath.children

    cd "sources" do
      system "./compile.sh"
      system "./output/bazel",
             "--output_user_root",
             buildpath/"output_user_root",
             "build",
             "scripts:bash_completion"

      bin.install "scripts/packages/bazel.sh" => "bazel"
      ln_s libexec/"bin/bazel-real", bin/"bazel-#{version}"
      (libexec/"bin").install "output/bazel" => "bazel-real"
      bin.env_script_all_files(libexec/"bin",
        JAVA_HOME: Formula["openjdk@11"].opt_libexec/"openjdk.jdk/Contents/Home")

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

    system bin/"bazel",
           "build",
           "//:bazel-test"
    assert_equal "Hi!\n", pipe_output("bazel-bin/bazel-test")

    # Verify that `bazel` invokes Bazel's wrapper script, which delegates to
    # project-specific `tools/bazel` if present. Invoking `bazel-VERSION`
    # bypasses this behavior.
    (testpath/"tools"/"bazel").write <<~EOS
      #!/bin/bash
      echo "stub-wrapper"
      exit 1
    EOS
    (testpath/"tools/bazel").chmod 0755

    assert_equal "stub-wrapper\n", shell_output("#{bin}/bazel --version", 1)
    assert_equal "bazel #{version}-homebrew\n", shell_output("#{bin}/bazel-#{version} --version")
  end
end
