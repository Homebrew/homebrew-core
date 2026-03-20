class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v17.1.8.tar.gz"
  sha256 "160649a998ae596de7223713854a22c853e492cb7d5ccf5c7f3223bddb2cb766"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f79a0e64e942b64396364200382adc5f882bee18cb07a28d7e17eb7a0637db11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f79a0e64e942b64396364200382adc5f882bee18cb07a28d7e17eb7a0637db11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f79a0e64e942b64396364200382adc5f882bee18cb07a28d7e17eb7a0637db11"
    sha256 cellar: :any_skip_relocation, sonoma:        "f79a0e64e942b64396364200382adc5f882bee18cb07a28d7e17eb7a0637db11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5090cb47788bdf6ad19a469116294e3ced4f8240b74116e4f222aa43efb8528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5090cb47788bdf6ad19a469116294e3ced4f8240b74116e4f222aa43efb8528"
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
