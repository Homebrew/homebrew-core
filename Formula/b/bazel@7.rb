class BazelAT7 < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/7.6.1/bazel-7.6.1-dist.zip"
  sha256 "c1106db93eb8a719a6e2e1e9327f41b003b6d7f7e9d04f206057990775a7760e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(7(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3713d9e3852d310fa144de0fa0672a821311e90b2fa5300f88ea07593086e24a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1978e98a12bd3f004583aa70d78c475dea2abecda8bf8bc470c858a95a659b7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9636883052ab0b877121020e61fd16995c8055696f6a947ebf28c46896c2951"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2a42269cc0ff8bc89a77a0845e1f066fdd2d32971b99cba72f2f765172c2e15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca27cb9ba9fb8c0035e866456aea3a718db3c891e53e722a7a7163d636f4e958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "539d749900289bdb1f9b4eed1a755f2fb0b949879354b3e89ee641fdf9a60224"
  end

  keg_only :versioned_formula

  # https://bazel.build/release#support-matrix
  deprecate! date: "2027-01-01", because: :unsupported

  depends_on "python@3.13" => :build
  depends_on "openjdk@21"

  uses_from_macos "unzip"
  uses_from_macos "zip"

  on_linux do
    on_intel do
      # We use a workaround to prevent modification of the `bazel-real` binary
      # but this means brew cannot rewrite paths for non-default prefix
      pour_bottle? only_if: :default_prefix
    end
  end

  # Fix to avoid fdopen() redefinition for vendored `zlib`
  # PR ref: https://github.com/bazelbuild/bazel/pull/26956
  patch do
    url "https://github.com/bazelbuild/bazel/commit/0d4c2130e356923849033c85d1d31c17372ce8f2.patch?full_index=1"
    sha256 "6196b60c916e0152eefbc79249758675a860b51c84a6dfd258e83b1698664067"
  end

  def bazel_real
    libexec/"bin/bazel-real"
  end

  def install
    # Workaround for "missing LC_UUID load command in .../xcode-locator"
    # https://github.com/bazelbuild/bazel/pull/27014
    inreplace "tools/osx/BUILD", " -Wl,-no_uuid ", " "

    java_home_env = Language::Java.java_home_env("21")

    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"
    # Force Bazel to use brew OpenJDK
    extra_bazel_args = ["--tool_java_runtime_version=local_jdk"]
    ENV.merge! java_home_env.transform_keys(&:to_s)
    # Bazel clears environment variables which breaks superenv shims
    ENV.remove "PATH", Superenv.shims_path

    # Set dynamic linker similar to cc shim so that bottle works on older Linux
    if OS.linux? && build.bottle? && ENV["HOMEBREW_DYNAMIC_LINKER"]
      extra_bazel_args << "--linkopt=-Wl,--dynamic-linker=#{ENV["HOMEBREW_DYNAMIC_LINKER"]}"
    end
    ENV["EXTRA_BAZEL_ARGS"] = extra_bazel_args.join(" ")

    (buildpath/"sources").install buildpath.children

    cd "sources" do
      system "./compile.sh"
      system "./output/bazel", "--output_user_root=#{buildpath}/output_user_root",
                               "build",
                               "scripts:bash_completion",
                               "scripts:fish_completion"

      bin.install "scripts/packages/bazel.sh" => "bazel"
      ln_s bazel_real, bin/"bazel-#{version}"
      (libexec/"bin").install "output/bazel" => "bazel-real"
      bin.env_script_all_files libexec/"bin", java_home_env

      bash_completion.install "bazel-bin/scripts/bazel-complete.bash" => "bazel"
      zsh_completion.install "scripts/zsh_completion/_bazel"
      fish_completion.install "bazel-bin/scripts/bazel.fish"
    end

    # Workaround to avoid breaking the zip-appended `bazel-real` binary.
    # Can remove if brew correctly handles these binaries or if upstream
    # provides an alternative in https://github.com/bazelbuild/bazel/issues/11842
    if OS.linux? && build.bottle?
      Utils::Gzip.compress(bazel_real)
      bazel_real.write <<~SHELL
        #!/bin/bash
        echo 'ERROR: Need to run `brew postinstall #{name}`' >&2
        exit 1
      SHELL
      bazel_real.chmod 0755
    end
  end

  def post_install
    if File.exist?("#{bazel_real}.gz")
      rm(bazel_real)
      system "gunzip", "#{bazel_real}.gz"
      bazel_real.chmod 0755
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

    (testpath/"BUILD").write <<~STARLARK
      java_binary(
        name = "bazel-test",
        srcs = glob(["*.java"]),
        main_class = "ProjectRunner",
      )
    STARLARK

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
