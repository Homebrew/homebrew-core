class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/4.0.0/bazel-4.0.0-dist.zip"
  sha256 "d350f80e70654932db252db380d2ec0144a00e86f8d9f2b4c799ffdb48e9cdd1"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8d9221e1fac2cc9b732ecaeffe8e5d83e2cd7bb4083006697d1828891e5777c" => :big_sur
    sha256 "03d9bae72a88eb463ca7fc05edd799d2b33193982a31368e5ea347bbdbfe4468" => :arm64_big_sur
    sha256 "5f98dfeab044d1178e7466334c3d5a90338bd1d2907a9f9797f0fc6ba6ed4490" => :catalina
    sha256 "6d62c70b69b6275216a182a5dc5fa10c8c73e5876367557e8a9f01465b48f649" => :mojave
  end

  depends_on "python@3.9" => :build
  depends_on "openjdk@11"

  uses_from_macos "zip"

  # Fix compilation on macOS 10.14 Mojave
  # Remove in the next release
  # See https://github.com/bazelbuild/bazel/pull/12882
  patch do
    url "https://github.com/bazelbuild/bazel/commit/092b4c10fa2a2552dc3a98544d637c02ea2865c7.patch?full_index=1"
    sha256 "273cf54bf4c0fe42fe8da959dc76fc1a3e768f3f3d4108bfd280728db022a308"
  end

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
