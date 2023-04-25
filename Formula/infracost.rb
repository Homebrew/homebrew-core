class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.20.tar.gz"
  sha256 "1c7c478d8fc5aa51cc1492fb6d3c747dbfcfe9c931ec2e54705dfd7eef249a30"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5d8fe255b9228d03f8487881853d621e3ca7b4f702ac71b53bef2274c40336b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5d8fe255b9228d03f8487881853d621e3ca7b4f702ac71b53bef2274c40336b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5d8fe255b9228d03f8487881853d621e3ca7b4f702ac71b53bef2274c40336b"
    sha256 cellar: :any_skip_relocation, ventura:        "f9f6a5c4bc3586c2361b91f5e857ec677ea98de847d9311bc2e32656d53b294a"
    sha256 cellar: :any_skip_relocation, monterey:       "f9f6a5c4bc3586c2361b91f5e857ec677ea98de847d9311bc2e32656d53b294a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9f6a5c4bc3586c2361b91f5e857ec677ea98de847d9311bc2e32656d53b294a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96a877f49a02a4371e70b94d25bc8c43c93bd16d5ed2daf422c302f232570468"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/infracost"

    generate_completions_from_executable(bin/"infracost", "completion", "--shell")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
