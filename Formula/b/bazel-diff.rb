class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/releases/download/9.0.3/bazel-diff_deploy.jar"
  sha256 "4a7dd64c7b1fb1219b825138c62c206d2ace7470aa5d3a07a554532e74048893"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8e16f516a376286f2a86ae079cfa297dec7030f62202bb2bbf92b5af8db3ac68"
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
