class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.21.tar.gz"
  sha256 "930aa4178b09fc7b63d4331f62776fecd5532d8d588e13c416047531385c826d"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "778277a955c6ab2ba8ed9a33db640c8ab4f6f2427a1f1423494360c03ef8188e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8fed68370e7ca4d660b6df24db3df6c64f9a6421b9200e9a603bef2c0ca59ba4"
    sha256 cellar: :any_skip_relocation, monterey:       "c3076d732e3cce24df98a3737366e19df1594b8e5d4fb047729cc0f5aaf5fc8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3076d732e3cce24df98a3737366e19df1594b8e5d4fb047729cc0f5aaf5fc8d"
    sha256 cellar: :any_skip_relocation, catalina:       "46e8cec548a607a47d1daea81da44af07448aefa59d9696b82e847de3f3be167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc02185d239ad506dbb911e0b16828ae00097065745c2d188a26d68f1329f1bd"
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
