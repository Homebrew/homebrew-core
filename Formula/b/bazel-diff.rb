class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v18.0.3.tar.gz"
  sha256 "64979b9247d7a6a1ee244becd940b7968473b08ac969bbdfd23d577cdf7c81c3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef4ec9a9cd01fdd7eda52024d66924a4cb4abc0d9f66425ddb25fac9dd9687a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef4ec9a9cd01fdd7eda52024d66924a4cb4abc0d9f66425ddb25fac9dd9687a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef4ec9a9cd01fdd7eda52024d66924a4cb4abc0d9f66425ddb25fac9dd9687a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef4ec9a9cd01fdd7eda52024d66924a4cb4abc0d9f66425ddb25fac9dd9687a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f1b9ccf9a73812cbdaf414bb4498d9d2d057095dc46a092635770fb4468bd57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f1b9ccf9a73812cbdaf414bb4498d9d2d057095dc46a092635770fb4468bd57"
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
