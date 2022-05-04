class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.24.tar.gz"
  sha256 "86c50095a4c9b61a8cb42e1c65c47da605466422a3b71d2353278eb9b2c11f60"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2071d5c7f67177cc3f18fd96d351bf8bb123c3a6f34b07c76481922a3a40201"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0874c2e73de6d95e3a5b70c31873d2d7696a152703e37b3ac441f7a373835bfa"
    sha256 cellar: :any_skip_relocation, monterey:       "0116670a708e78440ed6deaceb65591bed85549be4f694eaa4aa67867197a93f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0116670a708e78440ed6deaceb65591bed85549be4f694eaa4aa67867197a93f"
    sha256 cellar: :any_skip_relocation, catalina:       "0116670a708e78440ed6deaceb65591bed85549be4f694eaa4aa67867197a93f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f9ca5988f8002da453b86dceefec15f75893cb45b722a776b772d16c3fc2ab3"
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
