class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/releases/download/8.1.6/bazel-diff_deploy.jar"
  sha256 "81406df78cebc3144148e33955da676f7e8a55d406cda3982b0540a828ae0261"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ae8cbffe4f458640431e59fefdf71a52399ac32912002195f98b22835eec3e83"
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
