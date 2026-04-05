class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v18.0.2.tar.gz"
  sha256 "2401bedec85aab6bf0955785f1d9813be031f92c15a66b087198349e09e62359"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "795e0e868692550cfa9888c76b547469792346609b4537132272cb86e77de576"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "795e0e868692550cfa9888c76b547469792346609b4537132272cb86e77de576"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "795e0e868692550cfa9888c76b547469792346609b4537132272cb86e77de576"
    sha256 cellar: :any_skip_relocation, sonoma:        "795e0e868692550cfa9888c76b547469792346609b4537132272cb86e77de576"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4b75086e934598fa9ede44947e0340b6ab857678888b14da4798d9fd509b795"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4b75086e934598fa9ede44947e0340b6ab857678888b14da4798d9fd509b795"
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
