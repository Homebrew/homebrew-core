class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/releases/download/5.0.0/bazel-diff_deploy.jar"
  sha256 "7943790f690ad5115493da8495372c89f7895b09334cb4fee5174a8f213654dd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35d371f6f00712b2554240aebc7a05e41cccdf705c04f7cbc0c93a6248a4c3ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35d371f6f00712b2554240aebc7a05e41cccdf705c04f7cbc0c93a6248a4c3ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35d371f6f00712b2554240aebc7a05e41cccdf705c04f7cbc0c93a6248a4c3ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "35d371f6f00712b2554240aebc7a05e41cccdf705c04f7cbc0c93a6248a4c3ff"
    sha256 cellar: :any_skip_relocation, ventura:        "35d371f6f00712b2554240aebc7a05e41cccdf705c04f7cbc0c93a6248a4c3ff"
    sha256 cellar: :any_skip_relocation, monterey:       "35d371f6f00712b2554240aebc7a05e41cccdf705c04f7cbc0c93a6248a4c3ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85d40d6ce77c64b805640c495216f74ac405e0d7fdbf9254957f4ecc4a673a29"
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
