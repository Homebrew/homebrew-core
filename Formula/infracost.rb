class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.7.13.tar.gz"
  sha256 "785375744f2e6070d0af3f4f708954d682f645d02a5aa46827639addac0fc2e6"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "442a592e31fa3adedd7de4fe98cf0149e795bf782084f0128900b962b105733c" => :big_sur
    sha256 "95341e29738e12bf9c3b62da2a54511a066faf855509afe8807700edfd6fa0ea" => :catalina
    sha256 "089141f7e748ed1a66fe399cf4cdfa31932b78795c46b3c9fb813780ddd2cf6c" => :mojave
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
