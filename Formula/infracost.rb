class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.7.5.tar.gz"
  sha256 "ff31913fb22a24708b95b2265185715479424dc8623fc4b37bd46ed7b2dc89ac"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eed439c4e39210032fc1ba2c940f2738660970b49fb40f767e2c1f4dd712fe40" => :big_sur
    sha256 "74b7dcd92caaee6b6c64824b872791c484e0ad8205f0d6c5ab48252f029239c1" => :catalina
    sha256 "1ecd01fe2e01550a63bcef94806e90e9e6e4fd7ceb56367f33ac2ab18758e39a" => :mojave
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
