class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.7.7.tar.gz"
  sha256 "452a6a3348ea4fc98df62a1ee3d5a97e24c6453d8a4a134ed4e0ece720a08d82"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d8aab3d04ca05510fbc9a03039e8638b8d1e8bdd8fd7b4ee8c21804f8246821" => :big_sur
    sha256 "e8295a5c12cf579ffc8c5ce37fce86b561017d1b4a6537c8a624da42b5e20631" => :catalina
    sha256 "5f77001255c252628c2c31f36982f19c2b518e89c75e0fc4ace23b53182d4aee" => :mojave
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --help 2>&1")

    output = shell_output("#{bin}/infracost --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
