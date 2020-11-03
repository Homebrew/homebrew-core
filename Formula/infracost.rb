class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.7.0.tar.gz"
  sha256 "84e3299bc245e5ec4869285df83b1035eca18714beb5f5fbe0e08c2ef4ba6bae"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "79bebbe2594dc643b99d6d4f7c8ee6f3b68d82d024efadbaf6ef0cbe11e5ca76" => :catalina
    sha256 "a01fb13174cb3d21413fb0123cc3f3c6e849e57e063faa09912dada44de674b9" => :mojave
    sha256 "b5a91fffb2d6b5961dfc6102025dd06247e6b2d391735f9e0e6093f109f08136" => :high_sierra
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
