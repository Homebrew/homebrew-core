class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.6.4.tar.gz"
  sha256 "e8ff7bd05b6116c569b2c0d5fe4283a55d12b773d17be548af148a13b999b11c"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "13a8da2ec70e7a92f5a461daf4330db66fc26318185b0260f55cb5345c06ac3b" => :catalina
    sha256 "21d0f10ea82a5c014402c00919da081d808e8333bc45c7ddf9bbf5f6dde71c3c" => :mojave
    sha256 "c8f0857f86db16bc80c0dd79ee2eb6a025739dca7d4ccdc8ed5eb5830ae17a17" => :high_sierra
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
