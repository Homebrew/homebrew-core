class OktaAwsCli < Formula
  desc "Okta federated identity for AWS CLI"
  homepage "https://github.com/okta/okta-aws-cli"
  url "https://github.com/okta/okta-aws-cli/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "2d68b99fc8b16145169d3f7f780216bd9b4ec73eed48ee609bdecd2b99100f77"
  license "Apache-2.0"
  head "https://github.com/okta/okta-aws-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e7ed56735b06b45c7c08503291102b4d933b825d960142280a4956f64ea4d93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e7ed56735b06b45c7c08503291102b4d933b825d960142280a4956f64ea4d93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e7ed56735b06b45c7c08503291102b4d933b825d960142280a4956f64ea4d93"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b8257c2a91a3bb3665b238f94270b7e76e90757cea404191ef3b79ff04bcb40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2725d92b1b5bb4d9c8e53ae37c62364d850032419d64577623470e62dd269673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c38c00fe03b0d4944ba3ca2e094400242088bcc601dd460f4ba5602938ac9d2"
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
