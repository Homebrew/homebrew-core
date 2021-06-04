class IamPolicyJsonToTerraform < Formula
  desc "Convert a JSON IAM Policy into terraform"
  homepage "https://github.com/flosell/iam-policy-json-to-terraform"
  url "https://github.com/flosell/iam-policy-json-to-terraform/archive/1.7.0.tar.gz"
  sha256 "caba6d14c1f05f778f6928977f33bd0df0a1eef6266b667fc3a31512566f235a"
  license "Apache-2.0"
  head "https://github.com/flosell/iam-policy-json-to-terraform.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0cd31837517441cf8dee924b0562dd12e36f4805da4774eeb3aaea297f27bcae"
    sha256 cellar: :any_skip_relocation, big_sur:       "bf50450b2d2c6123a1905d362352f8d073c670cfbd6db9855c207de63e9e0c49"
    sha256 cellar: :any_skip_relocation, catalina:      "bf50450b2d2c6123a1905d362352f8d073c670cfbd6db9855c207de63e9e0c49"
    sha256 cellar: :any_skip_relocation, mojave:        "bf50450b2d2c6123a1905d362352f8d073c670cfbd6db9855c207de63e9e0c49"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    # test version
    assert_match version.to_s, shell_output("#{bin}/iam-policy-json-to-terraform -version")

    # test functionality
    test_input = '{"Statement":[{"Effect":"Allow","Action":["ec2:Describe*"],"Resource":"*"}]}'
    output = shell_output("echo '#{test_input}' | #{bin}/iam-policy-json-to-terraform")
    assert_match "ec2:Describe*", output
  end
end
