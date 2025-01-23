class IamPolicyJsonToTerraform < Formula
  desc "Convert a JSON IAM Policy into terraform"
  homepage "https://github.com/flosell/iam-policy-json-to-terraform"
  url "https://github.com/flosell/iam-policy-json-to-terraform/archive/refs/tags/1.8.2.tar.gz"
  sha256 "b771e27aa863e8ec899e36c858e6b78d788123f7784bfb3ece8e6350853a3f9b"
  license "Apache-2.0"
  head "https://github.com/flosell/iam-policy-json-to-terraform.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9eeaf2786425784134e48eb7452a4690777b47ba98622eb6e21ba91cffe97fa5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa5f0cec6807f3437d92a0a71cfb29b60c615cef638b3d7468ff4c9c762e62d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de0dd9eac2c92e6d872cb70a31297a302f86a2481ee3b8e8e88abcf400fa3638"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de0dd9eac2c92e6d872cb70a31297a302f86a2481ee3b8e8e88abcf400fa3638"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de0dd9eac2c92e6d872cb70a31297a302f86a2481ee3b8e8e88abcf400fa3638"
    sha256 cellar: :any_skip_relocation, sonoma:         "093d85bfdb441bdf70d666adab8e6e1c7f3497f2fa35f0abfc559053034ae5c8"
    sha256 cellar: :any_skip_relocation, ventura:        "45a53b59f71f30bac7149c65cf265e9ad8fd2089d1d3e378c6579fc9b3e0ae17"
    sha256 cellar: :any_skip_relocation, monterey:       "45a53b59f71f30bac7149c65cf265e9ad8fd2089d1d3e378c6579fc9b3e0ae17"
    sha256 cellar: :any_skip_relocation, big_sur:        "45a53b59f71f30bac7149c65cf265e9ad8fd2089d1d3e378c6579fc9b3e0ae17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adb27d7d5560c6a455a72d921653a07e4f808d717fc88e1796375b5158cb994a"
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
