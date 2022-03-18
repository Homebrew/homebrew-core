class IamPolicyJsonToTerraform < Formula
  desc "Convert a JSON IAM Policy into terraform"
  homepage "https://github.com/flosell/iam-policy-json-to-terraform"
  url "https://github.com/flosell/iam-policy-json-to-terraform/archive/1.8.0.tar.gz"
  sha256 "428ee4c7c40a77c3f2c08f1ea5b5ac145db684bba038ab113848e1697ef906dc"
  license "Apache-2.0"
  head "https://github.com/flosell/iam-policy-json-to-terraform.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "783a05da4dc552503162f5011070a1f6246ef0ab7d6303220c341ea068d7b7fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac00a7ac5a6ff93c27f096a6a8ff9e77cfbe65a18825f4d70411b0dfd93c64ed"
    sha256 cellar: :any_skip_relocation, monterey:       "111f500af6a74c541da583a20d594230e40f87710050038d8b494f1e961403c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "414adbbf759816cf41a250c66cf375e85d0d4e03d94cdb6b41aba59000f72b87"
    sha256 cellar: :any_skip_relocation, catalina:       "414adbbf759816cf41a250c66cf375e85d0d4e03d94cdb6b41aba59000f72b87"
    sha256 cellar: :any_skip_relocation, mojave:         "414adbbf759816cf41a250c66cf375e85d0d4e03d94cdb6b41aba59000f72b87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04e3ec2788df5965f842759d48c939efbd699fbcc66d2d3e000a6c844607630e"
  end

  # Bump to 1.18 on the next release.
  depends_on "go@1.17" => :build

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
