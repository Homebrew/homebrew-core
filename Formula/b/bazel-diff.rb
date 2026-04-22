class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v18.1.0.tar.gz"
  sha256 "0f77a67641d33e43da76e46f7deed7e26934d805346d7962ddd05def7744e9a3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13a59f8b4bfd79bd5d74808393664aba1112076e4f2a519002445c2eca3e63e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13a59f8b4bfd79bd5d74808393664aba1112076e4f2a519002445c2eca3e63e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13a59f8b4bfd79bd5d74808393664aba1112076e4f2a519002445c2eca3e63e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "13a59f8b4bfd79bd5d74808393664aba1112076e4f2a519002445c2eca3e63e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7bb0f6e08a5d1c629eadbbd7453d16a192781aa019a2f502b024dd82c235851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7bb0f6e08a5d1c629eadbbd7453d16a192781aa019a2f502b024dd82c235851"
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
