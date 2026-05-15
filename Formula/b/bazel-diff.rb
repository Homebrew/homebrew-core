class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v22.0.0.tar.gz"
  sha256 "17241cfa92f11dce83e7e4f577d1261bde3814d75511d665ae8dd7bb8673989e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f40656fb8d9bd9f3c12916eecadfac6db302bd2aa3c5ca982346d722ffbca1f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f40656fb8d9bd9f3c12916eecadfac6db302bd2aa3c5ca982346d722ffbca1f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f40656fb8d9bd9f3c12916eecadfac6db302bd2aa3c5ca982346d722ffbca1f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f40656fb8d9bd9f3c12916eecadfac6db302bd2aa3c5ca982346d722ffbca1f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04cc15929167e2c9e8dd3eb6efed2f0887cf8735e4cb9ad7278bd8720d784234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04cc15929167e2c9e8dd3eb6efed2f0887cf8735e4cb9ad7278bd8720d784234"
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
