class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.2.tar.gz"
  sha256 "25bc41fee2f7fb01cc8989d9e69ac2ca3c7d43a79fd3b9f47f40c61e91182c39"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "31428f57f0a27567099eb541ce8f944812031a131730a20fe6d4b359c1c00626"
    sha256 cellar: :any_skip_relocation, big_sur:       "529538fc0438c3f0702ee7018ca7d3c43866a35bea10205d7506039d61a5bcb6"
    sha256 cellar: :any_skip_relocation, catalina:      "529538fc0438c3f0702ee7018ca7d3c43866a35bea10205d7506039d61a5bcb6"
    sha256 cellar: :any_skip_relocation, mojave:        "529538fc0438c3f0702ee7018ca7d3c43866a35bea10205d7506039d61a5bcb6"
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
