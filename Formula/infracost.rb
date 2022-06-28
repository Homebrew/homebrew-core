class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.6.tar.gz"
  sha256 "b03c50d0707c41414cfca1fb08014b2e3435166523f7a4ddb72e450862cddf81"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23501c01bab17e09214f51e6a0842d877cc7b5045b13094dd61c03858a699ddd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6329c85acfdec783dd80fe3ba5c8d99db33a87f346aa54fdb6b88ebf40c061b"
    sha256 cellar: :any_skip_relocation, monterey:       "41de0d2b1baa6acd4720d326df8138c9c00b016d3b32289be0c416fac1ebc473"
    sha256 cellar: :any_skip_relocation, big_sur:        "41de0d2b1baa6acd4720d326df8138c9c00b016d3b32289be0c416fac1ebc473"
    sha256 cellar: :any_skip_relocation, catalina:       "ead7509c47ed20c5f2da6266468fa40bc3fe1c5202b9b0d37ad8a441bf3b27cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "304fe9945a203cfed26c9ef8579eefd33c00b889fda23e522831a3e4ace97bdc"
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
