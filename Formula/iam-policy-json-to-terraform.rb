class IamPolicyJsonToTerraform < Formula
  desc "Convert a JSON IAM Policy into terraform"
  homepage "https://github.com/flosell/iam-policy-json-to-terraform"
  url "https://github.com/flosell/iam-policy-json-to-terraform/archive/1.8.1.tar.gz"
  sha256 "601148725d0e0a114f59bd818982bd27c6868a2550114d429ef4411b98838615"
  license "Apache-2.0"
  head "https://github.com/flosell/iam-policy-json-to-terraform.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "230a186721c392312168f6942dd66ded8b9e1b103e98eca1d7f50f35e7b82aea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "230a186721c392312168f6942dd66ded8b9e1b103e98eca1d7f50f35e7b82aea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "230a186721c392312168f6942dd66ded8b9e1b103e98eca1d7f50f35e7b82aea"
    sha256 cellar: :any_skip_relocation, ventura:        "1e4e234b58119f95fccad7d0d1027f46681c5447bbe0164675a271ba224c263a"
    sha256 cellar: :any_skip_relocation, monterey:       "898a475ea6f2628b7972e43f1a5849c3fec9eec86ceb5117e56a68849dab87cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "898a475ea6f2628b7972e43f1a5849c3fec9eec86ceb5117e56a68849dab87cc"
    sha256 cellar: :any_skip_relocation, catalina:       "898a475ea6f2628b7972e43f1a5849c3fec9eec86ceb5117e56a68849dab87cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32c9e42a2c161b3ba1bc3765d21b08154e00bac3729232d25c1ee7de78f0b5d5"
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
    output = pipe_output("#{bin}/iam-policy-json-to-terraform", test_input)
    assert_match "ec2:Describe*", output
  end
end
