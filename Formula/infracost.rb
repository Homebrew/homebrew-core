class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.8.7.tar.gz"
  sha256 "2e2b027beb59c44a8ecee744d08f3c02f0d97fc07e5fbbf9d6f30fdb1c290992"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "989b266bd99f2a3bb6e413de7e434913b6b231a65bb0a9b0439575d89f2cda39"
    sha256 cellar: :any_skip_relocation, big_sur:       "56ffeec4e1b8c5db074f9bd7d2e08bfe6450866806822fd67e3fcfdc75d11bd7"
    sha256 cellar: :any_skip_relocation, catalina:      "56ffeec4e1b8c5db074f9bd7d2e08bfe6450866806822fd67e3fcfdc75d11bd7"
    sha256 cellar: :any_skip_relocation, mojave:        "56ffeec4e1b8c5db074f9bd7d2e08bfe6450866806822fd67e3fcfdc75d11bd7"
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
