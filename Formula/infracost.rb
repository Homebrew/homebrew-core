class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.21.tar.gz"
  sha256 "930aa4178b09fc7b63d4331f62776fecd5532d8d588e13c416047531385c826d"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5412ca5d8b64513e46f748505d84ab9d95af06e5c378b11c0f78d4377915c69c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5412ca5d8b64513e46f748505d84ab9d95af06e5c378b11c0f78d4377915c69c"
    sha256 cellar: :any_skip_relocation, monterey:       "191f3f6c53978437b05e2a4940fb57eb4dfee17ee40e07ec2bf19c7775527650"
    sha256 cellar: :any_skip_relocation, big_sur:        "191f3f6c53978437b05e2a4940fb57eb4dfee17ee40e07ec2bf19c7775527650"
    sha256 cellar: :any_skip_relocation, catalina:       "191f3f6c53978437b05e2a4940fb57eb4dfee17ee40e07ec2bf19c7775527650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97e99e452a1dc10de3525a79c33b6c14677ae53c0cef18f7404182a4704c6d61"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
