class OktaAwsCli < Formula
  desc "Okta federated identity for AWS CLI"
  homepage "https://github.com/okta/okta-aws-cli"
  url "https://github.com/okta/okta-aws-cli/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "26615db3644bea9e1f610a7d53dc83f366a64e46dbfd2efbe45284f1cb7b9e3b"
  license "Apache-2.0"
  head "https://github.com/okta/okta-aws-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e58aa4aa282022c36d1353d265dadaf40f78be077fcd8e39cedf27ab8e7aef63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e58aa4aa282022c36d1353d265dadaf40f78be077fcd8e39cedf27ab8e7aef63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e58aa4aa282022c36d1353d265dadaf40f78be077fcd8e39cedf27ab8e7aef63"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8c60a47a42b009829c814017fa65c1e573499626ac6b98d7af1ad97644f2402"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "070520ed3fb031e13f9c1a836b32c89541e18c7c8178aea70f99e5c8eb3f7181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a93368251368737cb1180d07acfa7eb2ff185888a6c688f0affe7885d94bfce"
  end

  depends_on "go" => :build

  # version patch, upstream pr ref, https://github.com/okta/okta-aws-cli/pull/292
  patch do
    url "https://github.com/okta/okta-aws-cli/commit/3d3d19ba7ea0925f61c3a090cf24d3647622b285.patch?full_index=1"
    sha256 "dfc56e683281c3c0b8ed310eb66ebcb75b9cc08479301b02a6da33d3b1d12f8f"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/okta-aws-cli"
  end

  test do
    output = shell_output("#{bin}/okta-aws-cli list-profiles")
    assert_match "Profiles:", output

    assert_match version.to_s, shell_output("#{bin}/okta-aws-cli --version")
  end
end
