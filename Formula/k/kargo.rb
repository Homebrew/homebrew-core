class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "de1fdddee478d4be259e4c49fbcf50e40df3d9e3396684be6c08262689bd577a"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c254fc8bb20668c0bdba34e01e8c43d54801677a6050cca106262fa20f66c5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e66ab4b24d247116bf3c76028b4ce6617d70757dfdbd3a204e75b5fb362b6d4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61078721af2e7acd3c733c68f64010d325fd739c8b4056f178a19c2f9b443d83"
    sha256 cellar: :any_skip_relocation, sonoma:        "6768a0678e67ef3f83832175fadbe25b539987ffc048ecf1ebc76bce564eb28f"
    sha256 cellar: :any_skip_relocation, ventura:       "d0fcc621dda1878231f6f7dac422b1168d8e0dd387b3d3ecdd9c56766f9ab74d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba9fe82c0acfe7e724a70979d875e029c0ebc0af55482dd3328cc2e58a4121f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "662352cc3b0b94bcad72cf697efa302f1a0fbb610a21c9a014d92d0c9f096ebe"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end
