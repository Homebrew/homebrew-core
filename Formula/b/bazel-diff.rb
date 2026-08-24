class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v44.0.1.tar.gz"
  sha256 "49b3835655852a8b87f13b2c0f4bca64b265e41700f44159b69b13130dac8e02"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f878c26dbb97dc9fd62244eea34cfee6a47bb48aea3ed75fdb88669ab6cc8d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f878c26dbb97dc9fd62244eea34cfee6a47bb48aea3ed75fdb88669ab6cc8d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f878c26dbb97dc9fd62244eea34cfee6a47bb48aea3ed75fdb88669ab6cc8d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f878c26dbb97dc9fd62244eea34cfee6a47bb48aea3ed75fdb88669ab6cc8d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c105ca532535ee03b4285eeccc4a783bd94468ec01141d1b9574c0c59e01dfbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c105ca532535ee03b4285eeccc4a783bd94468ec01141d1b9574c0c59e01dfbd"
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
