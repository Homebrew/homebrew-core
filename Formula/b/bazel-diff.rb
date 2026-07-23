class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v37.0.0.tar.gz"
  sha256 "618f7e726e3bc3b4039ecb3552eb843467fd02e10a8c2ff8cc31679ca520fb2c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dc29572780b0a0f3100269c5950873860470ef9220f3ed3dbe10bcf096e785c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dc29572780b0a0f3100269c5950873860470ef9220f3ed3dbe10bcf096e785c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dc29572780b0a0f3100269c5950873860470ef9220f3ed3dbe10bcf096e785c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1dc29572780b0a0f3100269c5950873860470ef9220f3ed3dbe10bcf096e785c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba947631414e7b9b5c2ef2c2163d64f9e225d5c8680c89cfd42afb9c7cd55750"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba947631414e7b9b5c2ef2c2163d64f9e225d5c8680c89cfd42afb9c7cd55750"
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
