class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/4.2.1/bazel-4.2.1-dist.zip"
  sha256 "12ea7aa11e2bdb12de1dceb9939a22e96f5a480437cb17c123379d8e0fdf5e82"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c3852bbeae030cebe6004eb714051adaf0e39ae02bdaacb5b22beae6665cf45f"
    sha256 cellar: :any_skip_relocation, big_sur:       "4e3ef1fcb3839d65621a635f4f6be6282e545563e5635ddad79a0b68bceee437"
    sha256 cellar: :any_skip_relocation, catalina:      "b59830d857e1ee86f119628524fa782127f71ba16a63f984f8f0b05a791c0405"
    sha256 cellar: :any_skip_relocation, mojave:        "31758f2ea241189a61feef8df58a12bb0d000c4bad4d79f2c9a2fe9f97c0d5ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "348e8fb910a6f9177bf79ac275b8a527194a81e002766bb48e010210550a7737"
  end

  depends_on "python@3.10" => :build
  depends_on "openjdk@11"

  uses_from_macos "unzip"
  uses_from_macos "zip"

  conflicts_with "bazelisk", because: "Bazelisk replaces the bazel binary"

  def install
    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"
    # Force Bazel to use openjdk@11
    ENV["EXTRA_BAZEL_ARGS"] = "--host_javabase=@local_jdk//:jdk"
    ENV["JAVA_HOME"] = Language::Java.java_home("11")
    # Force Bazel to use Homebrew python
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"

    # Bazel clears environment variables other than PATH during build, which
    # breaks Homebrew shim scripts. We don't see this issue on macOS since
    # the build uses a Bazel-specific wrapper for clang rather than the shim;
    # specifically, it uses `external/local_config_cc/wrapped_clang`.
    #
    # The workaround here is to disable the Linux shim for C/C++ compilers.
    # Remove this when a way to retain HOMEBREW_* variables is found.
    if OS.linux?
      ENV["CC"] = "/usr/bin/cc"
      ENV["CXX"] = "/usr/bin/c++"
    end

    (buildpath/"sources").install buildpath.children

    cd "sources" do
      system "./compile.sh"
      system "./output/bazel", "--output_user_root",
                               buildpath/"output_user_root",
                               "build",
                               "scripts:bash_completion"

      bin.install "scripts/packages/bazel.sh" => "bazel"
      ln_s libexec/"bin/bazel-real", bin/"bazel-#{version}"
      (libexec/"bin").install "output/bazel" => "bazel-real"
      bin.env_script_all_files libexec/"bin", Language::Java.java_home_env("11")

      bash_completion.install "bazel-bin/scripts/bazel-complete.bash"
      zsh_completion.install "scripts/zsh_completion/_bazel"
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
