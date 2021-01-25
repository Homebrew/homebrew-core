class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.7.15.tar.gz"
  sha256 "e6df4fedda4fcd0abc0feadcfe3e1309794ba758dbe5baa7dc3de6c96e8acff0"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "88a812be6e0c7c37977eb0798372d9ed5e6db13fda36656c4b3c633c3f26e79d" => :big_sur
    sha256 "557c6d5f233d2c26bd4aa97c49fe7e245cb9ef2223d455b298c64f1d1d62c849" => :arm64_big_sur
    sha256 "0ac1d6dbfe210c8fd9f8ab4c32865b58bd101007e29dd2268d221f844e1a66dd" => :catalina
    sha256 "d3f058e5e016bfe9f7208f7c6fb64404836c821a62b010df55262b4d4704b6a5" => :mojave
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
