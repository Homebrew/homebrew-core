class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/releases/download/4.8.2/bazel-diff_deploy.jar"
  sha256 "a88c267227a770b787ec939b64cca907efa6e1a1c0d5c55283d7332ddb05d3b5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dc62d7690c70fef398ae4ab0e47eb74e45806c10f55cd5569adbd8493d21890"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dc62d7690c70fef398ae4ab0e47eb74e45806c10f55cd5569adbd8493d21890"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7dc62d7690c70fef398ae4ab0e47eb74e45806c10f55cd5569adbd8493d21890"
    sha256 cellar: :any_skip_relocation, ventura:        "7dc62d7690c70fef398ae4ab0e47eb74e45806c10f55cd5569adbd8493d21890"
    sha256 cellar: :any_skip_relocation, monterey:       "7dc62d7690c70fef398ae4ab0e47eb74e45806c10f55cd5569adbd8493d21890"
    sha256 cellar: :any_skip_relocation, big_sur:        "7dc62d7690c70fef398ae4ab0e47eb74e45806c10f55cd5569adbd8493d21890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6144358a92857b8f62cc91a3ec10e38aa09852d80d7fa7657b1584312f6b01fa"
  end

  depends_on "bazel" => :test
  depends_on "openjdk"

  def install
    libexec.install "bazel-diff_deploy.jar"
    bin.write_jar_script libexec/"bazel-diff_deploy.jar", "bazel-diff"
  end

  test do
    output = shell_output("#{bin}/bazel-diff generate-hashes --workspacePath=#{testpath} 2>&1", 1)
    assert_match "Unexpected error during generation of hashes", output
  end
end
