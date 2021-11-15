class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.13.tar.gz"
  sha256 "27c21b3aebc6a95af398addfb6f92706863acbbdfeda35d751aced7ded465544"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d75dfa84070a4b6a5dac681364b70baf91844be3bf1e329e9c95cd71d931fa8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d75dfa84070a4b6a5dac681364b70baf91844be3bf1e329e9c95cd71d931fa8"
    sha256 cellar: :any_skip_relocation, monterey:       "9872263d12ba25d7c0db3950a24ca6dd2f766e87bc59fe7b01ab1c279a8ff2f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "9872263d12ba25d7c0db3950a24ca6dd2f766e87bc59fe7b01ab1c279a8ff2f4"
    sha256 cellar: :any_skip_relocation, catalina:       "9872263d12ba25d7c0db3950a24ca6dd2f766e87bc59fe7b01ab1c279a8ff2f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0e66f36569f980463d3dd3c0df1d93831af6c2829b0d9507491db151800956b"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
