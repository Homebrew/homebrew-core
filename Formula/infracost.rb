class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.8.1.tar.gz"
  sha256 "d7b230163e7f2a2340c2c06d40f60ece001a1054e2abdb41067b2d7593c39103"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dbeb62fd0f65d5ada69e59ef7e93664fc6afe02a28bbf9d552d55918297acea1"
    sha256 cellar: :any_skip_relocation, big_sur:       "830b2eea0d31e59256b1824516e4f43b99a487fa5f049f438c154e4f470df324"
    sha256 cellar: :any_skip_relocation, catalina:      "21f3b05be09a63377b4a390914da314dd09811931337dc06c6abbd51adc2224e"
    sha256 cellar: :any_skip_relocation, mojave:        "d4abe384c7622c3351849ceb8e2ed14ff4971f3b997cbcdfcb533e5a998ebc4a"
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
