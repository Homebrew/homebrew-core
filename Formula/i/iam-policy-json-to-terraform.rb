class IamPolicyJsonToTerraform < Formula
  desc "Convert a JSON IAM Policy into terraform"
  homepage "https://github.com/flosell/iam-policy-json-to-terraform"
  url "https://github.com/flosell/iam-policy-json-to-terraform/archive/refs/tags/1.9.2.tar.gz"
  sha256 "63a1a8cc21785e70d830b8fc8289c36250d232c432446e39a25c0da2f2f27067"
  license "Apache-2.0"
  head "https://github.com/flosell/iam-policy-json-to-terraform.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ed193284c1d8208faae3abd91d94659eb6fb11ef1b7e22c34b8bcb7996331eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ed193284c1d8208faae3abd91d94659eb6fb11ef1b7e22c34b8bcb7996331eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ed193284c1d8208faae3abd91d94659eb6fb11ef1b7e22c34b8bcb7996331eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ee1bf82c57af5d24d4afc9224ba88c3914e14c1c8c4b1436a15b71b48bcac64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d821d3d49518f09297da65d562f1a4a9cfb9d8fc3aae30dcb616a7286e5d090"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83859d9fba82033801b53077bcf0728c45db5a2f43f9765977aa94ca57b620f3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # test version
    assert_match version.to_s, shell_output("#{bin}/iam-policy-json-to-terraform -version")

    # test functionality
    test_input = '{"Statement":[{"Effect":"Allow","Action":["ec2:Describe*"],"Resource":"*"}]}'
    output = pipe_output(bin/"iam-policy-json-to-terraform", test_input)
    assert_match "ec2:Describe*", output
  end
end
