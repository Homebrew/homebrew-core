class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/17.1.0.tar.gz"
  sha256 "69a6b4519ed561008d124241d6ab182688fc098db5331e6adc4f3435df0f9cf2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ed505987bab4fa325694157e5772bb38f8521d159eb9ad799e62cbc06246642"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ed505987bab4fa325694157e5772bb38f8521d159eb9ad799e62cbc06246642"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ed505987bab4fa325694157e5772bb38f8521d159eb9ad799e62cbc06246642"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e96091c8788a31e0a41ff3f1a72ae56b8d9e3b9bcad6f45806ed16c28916aea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "587239f008a6387300acbddfda6304aba2b88f4cfa9a69dfce920f7612204fe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41b75f87c782eed2b126e593a4493c41d0bb246fbf67b5acfe3f6a7a354481d4"
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
