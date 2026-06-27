class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v28.0.0.tar.gz"
  sha256 "c893ef04ea16759e2de835038d6f222c15e53bcbbf8409e87edbf80fb268f197"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52dfee0d7426bcb51ddf5c046b17cf46d5db348f45f2fb0b8ccb6ebeed9ab1f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52dfee0d7426bcb51ddf5c046b17cf46d5db348f45f2fb0b8ccb6ebeed9ab1f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52dfee0d7426bcb51ddf5c046b17cf46d5db348f45f2fb0b8ccb6ebeed9ab1f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "52dfee0d7426bcb51ddf5c046b17cf46d5db348f45f2fb0b8ccb6ebeed9ab1f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e908eb2e41a9d1d62657d84c904960fdb1804c60279f0cfd7ad4643815845e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e908eb2e41a9d1d62657d84c904960fdb1804c60279f0cfd7ad4643815845e9"
  end

  depends_on "bazel" => [:build, :test]
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = formula_opt_prefix("openjdk")
    rm ".bazelversion"

    extra_bazel_args = %w[
      -c opt
      --@protobuf//bazel/toolchains:prefer_prebuilt_protoc
      --enable_bzlmod
      --java_runtime_version=local_jdk
      --tool_java_runtime_version=local_jdk
      --repo_contents_cache=
    ]

    system "bazel", "build", *extra_bazel_args, "//cli:bazel-diff_deploy.jar"

    libexec.install "bazel-bin/cli/bazel-diff_deploy.jar"
    bin.write_jar_script libexec/"bazel-diff_deploy.jar", "bazel-diff"
  end

  test do
    output = shell_output("#{bin}/bazel-diff generate-hashes --workspacePath=#{testpath} 2>&1", 1)
    assert_match "ERROR: The 'info' command is only supported from within a workspace", output
  end
end
