class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/7.4.1/bazel-7.4.1-dist.zip"
  sha256 "83386618bc489f4da36266ef2620ec64a526c686cf07041332caff7c953afaf5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d0e1ab6f5803279244b510d252b7da929451f871dd84bc69089de5399b23170"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "182820919fd8a4729c3769fad482783bc15f42da84b3128d9db5ffec2e6ec900"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3fff3607b0e68a3ef19810fe60418093e9ba3ac59fa6dc1af71a8187ba8c304a"
    sha256 cellar: :any_skip_relocation, sonoma:        "819cc3996a5b758d2ee1892f777c8236849fd480fd9b742d4fb11cf13598fee8"
    sha256 cellar: :any_skip_relocation, ventura:       "d8d1a7f56fd5131c04fdf8c12056dbbee07252f371e0971d684591cec46600cc"
  end

  depends_on "python@3.13" => :build
  depends_on "openjdk@21"

  uses_from_macos "unzip"
  uses_from_macos "zip"

  conflicts_with "bazelisk", because: "Bazelisk replaces the bazel binary"

  def install
    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"
    # Force Bazel to use openjdk@21
    ENV["EXTRA_BAZEL_ARGS"] = "--tool_java_runtime_version=local_jdk"
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    # Force Bazel to use Homebrew python
    ENV.prepend_path "PATH", Formula["python@3.13"].opt_libexec/"bin"

    # Bazel clears environment variables other than PATH during build, which
    # breaks Homebrew's shim scripts that need HOMEBREW_* variables.
    # Bazel's build also resolves the realpath of executables like `cc`,
    # which breaks Homebrew's shim scripts that expect symlink paths.
    #
    # The workaround here is to disable the shim for C/C++ compilers.
    ENV["CC"] = "/usr/bin/cc"
    ENV["CXX"] = "/usr/bin/c++" if OS.linux?

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
      bin.env_script_all_files libexec/"bin", Language::Java.java_home_env("21")

      bash_completion.install "bazel-bin/scripts/bazel-complete.bash" => "bazel"
      zsh_completion.install "scripts/zsh_completion/_bazel"
      fish_completion.install "bazel-bin/scripts/bazel.fish"
    end
  end

  test do
    touch testpath/"WORKSPACE"

    (testpath/"ProjectRunner.java").write <<~JAVA
      public class ProjectRunner {
        public static void main(String args[]) {
          System.out.println("Hi!");
        }
      }
    JAVA

    (testpath/"BUILD").write <<~EOS
      java_binary(
        name = "bazel-test",
        srcs = glob(["*.java"]),
        main_class = "ProjectRunner",
      )
    EOS

    system bin/"bazel", "build", "//:bazel-test"
    assert_equal "Hi!\n", shell_output("bazel-bin/bazel-test")

    # Verify that `bazel` invokes Bazel's wrapper script, which delegates to
    # project-specific `tools/bazel` if present. Invoking `bazel-VERSION`
    # bypasses this behavior.
    (testpath/"tools/bazel").write <<~SHELL
      #!/bin/bash
      echo "stub-wrapper"
      exit 1
    SHELL
    (testpath/"tools/bazel").chmod 0755

    assert_equal "stub-wrapper\n", shell_output("#{bin}/bazel --version", 1)
    assert_equal "bazel #{version}-homebrew\n", shell_output("#{bin}/bazel-#{version} --version")
  end
end
