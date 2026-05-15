class BazelAT7 < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/7.7.1/bazel-7.7.1-dist.zip"
  sha256 "6181b3570c2f657d989b1141fb0c1a08eb5f08106ca577dc7dc52e7d0238379a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(7(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9951a2c2d7fb46a35db66a6a9adbc96b4ca75d184f0fa78545979b3e203b26cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9951a2c2d7fb46a35db66a6a9adbc96b4ca75d184f0fa78545979b3e203b26cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0f609c4a1e3092ab0a738f36ff02b0023f86fce0fabad542c375c6a9286bf3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e304d2c45194de90324fb87be2cafb3a2bc4a32449676f2045114354c96b6d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53a676cca2f198259a54d153ccbca884b6ff31046fe6d39cad15a3df20cd1eac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "551daae69da44de6887ed21c29cfb5705c5dfd92be88fa47b9aeeb03adee474c"
  end

  keg_only :versioned_formula

  # https://bazel.build/release#support-matrix
  deprecate! date: "2027-01-01", because: :unsupported

  depends_on "openjdk@21"

  uses_from_macos "python" => :build
  uses_from_macos "unzip"
  uses_from_macos "zip"

  on_linux do
    # We use a workaround to prevent modification of the `bazel-real` binary
    # but this means brew cannot rewrite paths for non-default prefix
    pour_bottle? only_if: :default_prefix
  end

  def bazel_real
    libexec/"bin/bazel-real"
  end

  def install
    java_home_env = Language::Java.java_home_env("21")

    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # https://github.com/bazelbuild/bazel/issues/27401
    ENV["BAZEL_DEV_VERSION_OVERRIDE"] = ENV["EMBED_LABEL"]
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
