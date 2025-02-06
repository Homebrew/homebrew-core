class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/releases/download/9.0.0/bazel-diff_deploy.jar"
  sha256 "5f36e74a8d6167e4d31f663526a63be3e3728456d8b5b4a84503315dd10e65e7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dff042f705e90139a0966ad0206f7ebbff19fdef4ee851a5d6b8efeec23a91b1"
  end

  depends_on "bazel" => :test
  depends_on "openjdk"

  def install
    libexec.install "bazel-diff_deploy.jar"
    bin.write_jar_script libexec/"bazel-diff_deploy.jar", "bazel-diff"
  end

  test do
    output = shell_output("#{bin}/bazel-diff generate-hashes --workspacePath=#{testpath} 2>&1", 1)
    assert_match "ERROR: The 'info' command is only supported from within a workspace", output
  end
end
