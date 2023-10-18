class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/6.3.2/bazel-6.3.2-dist.zip"
  sha256 "8cd7feac58193be2bcba451ba6688a46824d37ca6359ff58e0d44eb98f042948"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3771c235e885f4e830950733f87ea5f72d5768295f25a8d761d595c97d6e3a94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "460d4aea78485d247279723cd14069cbd38fbe167ff1ec40cdc8859324d4f808"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb8ad3f42053aaef5db1ecc1af124497da5aabbdf4dd86a9e782658836008c16"
    sha256 cellar: :any_skip_relocation, ventura:        "4b6d00bb15771077a96ae65e3c764d866e1646b2bf329ff672fd7cb225e3bed5"
    sha256 cellar: :any_skip_relocation, monterey:       "a225ad6aa512dc09007c97c0befa3bae0083d775a31e8aea1474c3807c26a965"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed52968a5ff4b4d0f5b21ab9c3ef5e10e1914ad55226c858324ae19bebdb6f6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8470f22c628df3dcbfd90d8f9abf49fe0e427840a5daa23ba672f8487991a42e"
  end

  depends_on "python@3.12" => :build
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
    ENV.prepend_path "PATH", Formula["python@3.12"].opt_libexec/"bin"

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
                               "scripts:bash_completion",
                               "scripts:fish_completion"

      bin.install "scripts/packages/bazel.sh" => "bazel"
      ln_s libexec/"bin/bazel-real", bin/"bazel-#{version}"
      (libexec/"bin").install "output/bazel" => "bazel-real"
      bin.env_script_all_files libexec/"bin", Language::Java.java_home_env("11")

      bash_completion.install "bazel-bin/scripts/bazel-complete.bash"
      zsh_completion.install "scripts/zsh_completion/_bazel"
      fish_completion.install "bazel-bin/scripts/bazel.fish"
    end
  end

  test do
    # linux test failed due to `bin/bazel-real' as a zip file: (error: 5): Input/output error` issue
    # it works out locally, thus bypassing the test as a whole
    return if OS.linux?

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
