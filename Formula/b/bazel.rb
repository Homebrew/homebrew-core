class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/8.4.1/bazel-8.4.1-dist.zip"
  sha256 "c434966629e32ba370741f95f5434a8f0b5279a87991d883a354476e8062565f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78f8d77fb595ac904e99eb9477767f91af35d5ca865e0b33c90efa1dba12fb07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "199040fea7ec859df31cc65a1641c8c6ff213994eb2a95a40a930207c0e4c201"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7af9dc7bed407258befd49445139d8aafe6b38b4ca510f400952cd07cb865b92"
    sha256 cellar: :any_skip_relocation, sonoma:        "591e0668176cf21218463b839cef37df2873ec6b085ed7f3f4e20cb4dccab190"
    sha256 cellar: :any_skip_relocation, ventura:       "e8b52183ffab2218a8cafb27bb4220e78f8a6be8d08b24f45a0051e55c545586"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "073a04829902099d2b6e85a1e1eba60f801fe2e51aed44d7a2477371014569a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d784c1ac4555722200d3bfd78eba38db1f0842083ddfa27bc8c1758cc483d2fa"
  end

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

  conflicts_with "bazelisk", because: "Bazelisk replaces the bazel binary"

  def bazel_real
    libexec/"bin/bazel-real"
  end

  # The following patches fix a `missing LC_UUID load command` error from dyld.
  # 1. Remove xcode_locator's no_uuid and codesigning workarounds
  #    https://github.com/bazelbuild/bazel/pull/27014
  patch do
    url "https://github.com/bazelbuild/bazel/commit/fa574ecffd8dc69df654bc27cd5e149351c2f5e8.patch?full_index=1"
    sha256 "8a76251f40fce9c4616e741fbc4766cf95827ee89e5402f3e35f4bc5621a588e"
  end
  # 2. Update apple_support dependency to pick up the following commit that
  #    fixes the same issue:
  #    https://github.com/bazelbuild/apple_support/commit/44c43c715aa58d16dc713ec0daa0a4373c39245a
  patch :DATA

  def install
    java_home_env = Language::Java.java_home_env("21")

    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"
    # Force Bazel to use brew OpenJDK
    extra_bazel_args = ["--tool_java_runtime_version=local_jdk"]
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
    assert_equal "bazel #{version}-homebrew\n", shell_output("#{bin}/bazel-#{version} --version")
  end
end

__END__
diff --git a/MODULE.bazel b/MODULE.bazel
index 4dbb1bf3b7..029f4c9181 100644
--- a/MODULE.bazel
+++ b/MODULE.bazel
@@ -38,7 +38,7 @@ bazel_dep(name = "chicory", version = "1.1.0")

 # Depend on apple_support first and then rules_cc so that the Xcode toolchain
 # from apple_support wins over the generic Unix toolchain from rules_cc.
-bazel_dep(name = "apple_support", version = "1.18.1")
+bazel_dep(name = "apple_support", version = "1.23.1")
 bazel_dep(name = "rules_cc", version = "0.1.1")

 # repo_name needs to be used, until WORKSPACE mode is to be supported in bazel_tools
