class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.8.3.tar.gz"
  sha256 "a20fac86544039c663215772cb4882f41117f4aedbe41dbba3feb1f961f1bb2d"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d1b9f2964f2cacf98a801f33d48e9d18a5d9e0dd67aa55e83706961ad9bf3993"
    sha256 cellar: :any_skip_relocation, big_sur:       "372b50cc4fb5e7c17ffdf4c211f6ff4bb9049686e9084f3a9cba32ba0a6fcaf3"
    sha256 cellar: :any_skip_relocation, catalina:      "2e7092cf9d02cbeb687e8a8656131f05ffcc555dfba7cf197731d8d0c66d601c"
    sha256 cellar: :any_skip_relocation, mojave:        "cab6774f1b367149e216322f27e83bb1b3ff64902a1e9c40584006302b1f7d9c"
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
