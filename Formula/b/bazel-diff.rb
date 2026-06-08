class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v25.0.0.tar.gz"
  sha256 "2f18750f9b5947755df9c88afcfffcc382c21cc23cb38b7d8746ab4bd96bc6c2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caa19bb4f81e7271cda0f5a72ee51dcbc7183cf10c6f3daa388529daa0d74d31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "caa19bb4f81e7271cda0f5a72ee51dcbc7183cf10c6f3daa388529daa0d74d31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caa19bb4f81e7271cda0f5a72ee51dcbc7183cf10c6f3daa388529daa0d74d31"
    sha256 cellar: :any_skip_relocation, sonoma:        "caa19bb4f81e7271cda0f5a72ee51dcbc7183cf10c6f3daa388529daa0d74d31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "950c98e57f00808f08a6c134a5d9f576b083d0fd12a60bec2c45d2632aaff58e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "950c98e57f00808f08a6c134a5d9f576b083d0fd12a60bec2c45d2632aaff58e"
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
