class OktaAwsCli < Formula
  desc "Okta federated identity for AWS CLI"
  homepage "https://github.com/okta/okta-aws-cli"
  url "https://github.com/okta/okta-aws-cli/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "e47f39fd2021cbcc3c86e0bfb96ee46aad506b8de4f35935a5cb86d8fd33e939"
  license "Apache-2.0"
  head "https://github.com/okta/okta-aws-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "391a7c50e9b1c816c5b65122d29d6aacaadd19d01520e2c134774ad0ae592648"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "391a7c50e9b1c816c5b65122d29d6aacaadd19d01520e2c134774ad0ae592648"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "391a7c50e9b1c816c5b65122d29d6aacaadd19d01520e2c134774ad0ae592648"
    sha256 cellar: :any_skip_relocation, sonoma:        "89981ade5d232179f4f30d9842286cbcec53b012db792edce069837d8496eaf0"
    sha256 cellar: :any_skip_relocation, ventura:       "89981ade5d232179f4f30d9842286cbcec53b012db792edce069837d8496eaf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0722e0df4cd81b34ebe80025de7393276c27ad51961f0691c31838ae810651e4"
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
