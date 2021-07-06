class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.3.tar.gz"
  sha256 "ad6a5786bb7c3efc69250bf183e44103df178c46af913df62e572a5849f73245"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "90038e570bcadb843763b6fa0c3d7d739f98b7f047856ddd955d9f4173d317d8"
    sha256 cellar: :any_skip_relocation, big_sur:       "3318f0b58a3bbc200c3cb92dbbb1e01d1a8681c677ec37633220031f18ba9830"
    sha256 cellar: :any_skip_relocation, catalina:      "3318f0b58a3bbc200c3cb92dbbb1e01d1a8681c677ec37633220031f18ba9830"
    sha256 cellar: :any_skip_relocation, mojave:        "3318f0b58a3bbc200c3cb92dbbb1e01d1a8681c677ec37633220031f18ba9830"
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
