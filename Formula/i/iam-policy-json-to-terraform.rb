class IamPolicyJsonToTerraform < Formula
  desc "Convert a JSON IAM Policy into terraform"
  homepage "https://github.com/flosell/iam-policy-json-to-terraform"
  url "https://github.com/flosell/iam-policy-json-to-terraform/archive/refs/tags/1.9.1.tar.gz"
  sha256 "5943b0a352758d4a6e9d7d759fd10af24f42abe7012b862cf92048b6dc6e15fb"
  license "Apache-2.0"
  head "https://github.com/flosell/iam-policy-json-to-terraform.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "016bb0b29e4f5c61e1c7e0e0c99ba74757327a146ddf9906df1d628694e31ae2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "016bb0b29e4f5c61e1c7e0e0c99ba74757327a146ddf9906df1d628694e31ae2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "016bb0b29e4f5c61e1c7e0e0c99ba74757327a146ddf9906df1d628694e31ae2"
    sha256 cellar: :any_skip_relocation, sonoma:        "717be4d1e9c56ce0f37199dee4b9d7e2055f166cc47b56101e7f2f9d22c6d8a3"
    sha256 cellar: :any_skip_relocation, ventura:       "717be4d1e9c56ce0f37199dee4b9d7e2055f166cc47b56101e7f2f9d22c6d8a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92ee9be34d8a9dddfe40f1a969683233cd80495d87f3d91956292db8b13c8846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f62890eb65845d86e84179b17762c573d9f77a1cafbe3bba430f73602f9b3ff"
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
