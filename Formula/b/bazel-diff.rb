class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v19.0.3.tar.gz"
  sha256 "12a20d2c268520e8fe45fc5f933111d1414a79887a02f723e677c6270d6e4fdc"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "defd019712ba22b223b3218ceb18bfce9a743b9e3cdc6c72d640516e0d9112e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "defd019712ba22b223b3218ceb18bfce9a743b9e3cdc6c72d640516e0d9112e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "defd019712ba22b223b3218ceb18bfce9a743b9e3cdc6c72d640516e0d9112e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "defd019712ba22b223b3218ceb18bfce9a743b9e3cdc6c72d640516e0d9112e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dcbdaeba55294411dfa29ad4c584f2d1a34c4bf1d3e7d61e92b314d498cd240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dcbdaeba55294411dfa29ad4c584f2d1a34c4bf1d3e7d61e92b314d498cd240"
  end

  depends_on "bazel" => [:build, :test]
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
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
