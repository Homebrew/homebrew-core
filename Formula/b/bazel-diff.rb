class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/releases/download/17.0.2/release.tar.gz"
  sha256 "110d0e24763119cf84a5fbe341570077c1928806d21aabf83c43dfb137274caf"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e4a30bac1f4f331f7e64a61c0bd3669c7034656402eba8eee9c52b6497855f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e4a30bac1f4f331f7e64a61c0bd3669c7034656402eba8eee9c52b6497855f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e4a30bac1f4f331f7e64a61c0bd3669c7034656402eba8eee9c52b6497855f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d43e46094e8f59010f4f16bb6d7250b7e922b9ac55fc2c75132652ce32f92671"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "409dbc2c3ce7ff09bc4b5357daf851d4c020d76eb9f18b01bb5c055ecee1b01f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d9cfbe5ff4a627d86aea5afcf932206da2f8cc132ed56c5c8973c854ebc4ceb"
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
