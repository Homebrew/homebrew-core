class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/9.0.0/bazel-9.0.0-dist.zip"
  sha256 "dfa496089624d726a158afcac353725166f81c5708ee1ecc9e662f2891b3544d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b93b8c24160c8008e82e14cf343bf965d903d5f389a9953775675941f9517a3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b93b8c24160c8008e82e14cf343bf965d903d5f389a9953775675941f9517a3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8ed51284a3f0ff6134237ba61a0c6bd9f9758b125b51e9e5d2f9f7f9db4248d"
    sha256 cellar: :any_skip_relocation, sonoma:        "07e3928b177f750d658ebc419aebc2310078f6eb0c887b04376359a0b1143d8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "223f7372762ef62f8cb2ace6d3cd4903529ad09e02b57f4d8be9e1ea3ac83c8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc9980313a5778b1bfbe939a02d35790681fc92ad6e0e7d9c99b9569ba10a936"
  end

  depends_on "openjdk@21"

  uses_from_macos "python" => :build
  uses_from_macos "unzip"
  uses_from_macos "zip"

  on_linux do
    on_arm do
      # Workaround for "/usr/bin/ld.gold: internal error in try_fix_erratum_843419_optimized"
      # Issue ref: https://sourceware.org/bugzilla/show_bug.cgi?id=31182
      depends_on "lld" => :build

      # We use a workaround to prevent modification of the `bazel-real` binary
      # but this means brew cannot rewrite paths for non-default prefix
      pour_bottle? only_if: :default_prefix
    end
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  conflicts_with "bazelisk", because: "Bazelisk replaces the bazel binary"

  def bazel_real
    libexec/"bin/bazel-real"
  end

  def install
    java_home_env = Language::Java.java_home_env("21")

    ENV["EMBED_LABEL"] = "#{version} #{tap.user}"
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"
    # Force Bazel to use brewed OpenJDK and PATH
    extra_bazel_args = %w[--tool_java_runtime_version=local_jdk --action_env=PATH --host_action_env=PATH --isatty=no]
    ENV.merge! java_home_env.transform_keys(&:to_s)
    # Bazel clears environment variables which breaks superenv shims
    ENV.remove "PATH", Superenv.shims_path

    # Workaround to build zlib < 1.3.1 with Apple Clang 1700
    # https://releases.llvm.org/18.1.0/tools/clang/docs/ReleaseNotes.html#clang-frontend-potentially-breaking-changes
    # Issue ref: https://github.com/bazelbuild/bazel/issues/25124
    if DevelopmentTools.clang_build_version >= 1700
      extra_bazel_args += %w[--copt=-fno-define-target-os-macros --host_copt=-fno-define-target-os-macros]
    end

    # Set dynamic linker similar to cc shim so that bottle works on older Linux
    if OS.linux? && build.bottle? && ENV["HOMEBREW_DYNAMIC_LINKER"]
      extra_bazel_args << "--linkopt=-Wl,--dynamic-linker=#{ENV["HOMEBREW_DYNAMIC_LINKER"]}"
    end

    if OS.linux? && Hardware::CPU.arch == :arm64
      extra_bazel_args << "--linkopt=-fuse-ld=lld"
      extra_bazel_args << "--host_linkopt=-fuse-ld=lld"
    end

    ENV["EXTRA_BAZEL_ARGS"] = extra_bazel_args.join(" ")

    (buildpath/"sources").install buildpath.children

    cd "sources" do
      system "./compile.sh"
      system "./output/bazel", "--output_user_root=#{buildpath}/output_user_root",
                               "build",
                               *extra_bazel_args,
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
    (testpath/"MODULE.bazel").write <<~STARLARK
      bazel_dep(name = "rules_java", version = "9.5.0")
    STARLARK

    (testpath/"ProjectRunner.java").write <<~JAVA
      public class ProjectRunner {
        public static void main(String args[]) {
          System.out.println("Hi!");
        }
      }
    JAVA

    (testpath/"BUILD").write <<~STARLARK
      load("@rules_java//java:defs.bzl", "java_binary")

      java_binary(
        name = "bazel-test",
        srcs = glob(["*.java"]),
        main_class = "ProjectRunner",
      )
    STARLARK

    # Explicitly disable repo contents cache
    system bin/"bazel", "build", "//:bazel-test", "--repo_contents_cache="
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
    assert_match "bazel #{version}", shell_output("#{bin}/bazel-#{version} --version")
  end
end
