class OktaAwsCli < Formula
  desc "Okta federated identity for AWS CLI"
  homepage "https://github.com/okta/okta-aws-cli"
  url "https://github.com/okta/okta-aws-cli/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "10756cfa6322c46dae99cf34a7826948aab1d4c3b615b819d4e732b89a27b6b2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f88a2cfa560718f62f75e5fd2373445e902d25f4612a89b3ddcefa24d6f2b62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f88a2cfa560718f62f75e5fd2373445e902d25f4612a89b3ddcefa24d6f2b62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f88a2cfa560718f62f75e5fd2373445e902d25f4612a89b3ddcefa24d6f2b62"
    sha256 cellar: :any_skip_relocation, sonoma:        "59b537176bf3630d471ef36948b4ca50523f0feb68c08d16a32929e64bd9507f"
    sha256 cellar: :any_skip_relocation, ventura:       "59b537176bf3630d471ef36948b4ca50523f0feb68c08d16a32929e64bd9507f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5b75f95d8e4d298f3d350c6a8eda64629b9e96816dbbdbae046ba2952ae9625"
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
