class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v31.4.0.tar.gz"
  sha256 "b67b6bd2a6fae778bdaac5d98ffcc3a81726f7312b692eea4faedf8436f6c051"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e421023b74a258d72d44a79c7e6b620e08eacf670a8ce4231eb3b55bf0a8256"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e421023b74a258d72d44a79c7e6b620e08eacf670a8ce4231eb3b55bf0a8256"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e421023b74a258d72d44a79c7e6b620e08eacf670a8ce4231eb3b55bf0a8256"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e421023b74a258d72d44a79c7e6b620e08eacf670a8ce4231eb3b55bf0a8256"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "378b820e735598ae10f22c7eadd6bd96f091e80b4d6f62bf6a8813c2ca48cebe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "378b820e735598ae10f22c7eadd6bd96f091e80b4d6f62bf6a8813c2ca48cebe"
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
