class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.7.20.tar.gz"
  sha256 "bd9a6a48e8b20957360a101948be6960aac9b4e28136a3c1d45203f442025d42"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4524b07becd6454baf7d8a091f85a568f1ab99b78a3d3a7e98829447ce2d22cb"
    sha256 cellar: :any_skip_relocation, big_sur:       "bad0d940d04b9fac2166ad3ff97460c54003227574dcdd5a47f623909d967e30"
    sha256 cellar: :any_skip_relocation, catalina:      "a0c77d74b8988968ff061be4ad7d9fc0a6d14824ac53aeddc98ef55b15b92d43"
    sha256 cellar: :any_skip_relocation, mojave:        "096b39e90d4eed6f1fc03cad8753f0f15b3f3a9133c44978289755b8f981e84b"
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
