class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/3.4.1/bazel-3.4.1-dist.zip"
  sha256 "27af1f11c8f23436915925b25cf6e1fb07fccf2d2a193a307c93437c60f63ba8"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "1193fc27675bf7e6ae515843c29ee63c07075c57f2e99326ea8dd15217dc656c" => :catalina
    sha256 "425bce3d822d4c96b290ffda9907eeb3ddd03322f41f6da412bf7f0f20cb7f4b" => :mojave
    sha256 "8c8a303ceea75353b0ae4941980efd03fe09e3097bea6efd73d927e876c5d8c3" => :high_sierra
  end

  depends_on "python@3.8" => :build
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
