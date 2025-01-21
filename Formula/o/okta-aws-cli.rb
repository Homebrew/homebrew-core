class OktaAwsCli < Formula
  desc "Okta federated identity for AWS CLI"
  homepage "https://github.com/okta/okta-aws-cli"
  url "https://github.com/okta/okta-aws-cli/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "610eef917edfb36990fcb0e8f3a2cd8132cbf95b3ec25c659db5f1e69780a0b3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e0f7d81bc77e4258a4602ad330bed1322a1e11b2962b879e0f6c02e688726398"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d309a14d4647fea7c98f4dbb12483cd12f18351884b1dc12a3304efb3dfb9144"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d309a14d4647fea7c98f4dbb12483cd12f18351884b1dc12a3304efb3dfb9144"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d309a14d4647fea7c98f4dbb12483cd12f18351884b1dc12a3304efb3dfb9144"
    sha256 cellar: :any_skip_relocation, sonoma:         "91723498e6a4789fc539c2e1f00b47113ce558004a9ca5dd6dc40ce3d4f4ae86"
    sha256 cellar: :any_skip_relocation, ventura:        "91723498e6a4789fc539c2e1f00b47113ce558004a9ca5dd6dc40ce3d4f4ae86"
    sha256 cellar: :any_skip_relocation, monterey:       "91723498e6a4789fc539c2e1f00b47113ce558004a9ca5dd6dc40ce3d4f4ae86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11a1b28d3037d75845e614d9878499afa7629654dbd40889435084b966533904"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/okta-aws-cli"
  end

  test do
    output = shell_output("#{bin}/okta-aws-cli list-profiles")
    assert_match "Profiles:", output

    assert_match version.to_s, shell_output("#{bin}/okta-aws-cli --version")
  end
end
