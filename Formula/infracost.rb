class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.5.tar.gz"
  sha256 "34bc174e31f28fd951e33110f376240654504e7945d500b491e26117952c34a7"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a1a9d10cc8d2e0f80cf4497452f666e89affbf4205be6279df1f76d903ee5f54"
    sha256 cellar: :any_skip_relocation, big_sur:       "fbf4c99007613e04fe228c0dd171098711bf607dafabe202a01132136ba6fc78"
    sha256 cellar: :any_skip_relocation, catalina:      "fbf4c99007613e04fe228c0dd171098711bf607dafabe202a01132136ba6fc78"
    sha256 cellar: :any_skip_relocation, mojave:        "fbf4c99007613e04fe228c0dd171098711bf607dafabe202a01132136ba6fc78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fd9b76284a60a15d126627376ee91f99c87f501bd71f7ea94f961fda361684e"
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
