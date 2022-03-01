class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.19.tar.gz"
  sha256 "c2987aa501e1049f57f6187f00637211cd6faea724db0eb3a71af260a40b68cc"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "593eabe2cd28a68fbb96a30ef49a507c01e4d5cd080dbcfa86a6ebc3ea648710"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "593eabe2cd28a68fbb96a30ef49a507c01e4d5cd080dbcfa86a6ebc3ea648710"
    sha256 cellar: :any_skip_relocation, monterey:       "577b00fff5b8109caefafd33a5cc0dc1cb05a820d5105d4c31a11aaf86859382"
    sha256 cellar: :any_skip_relocation, big_sur:        "577b00fff5b8109caefafd33a5cc0dc1cb05a820d5105d4c31a11aaf86859382"
    sha256 cellar: :any_skip_relocation, catalina:       "577b00fff5b8109caefafd33a5cc0dc1cb05a820d5105d4c31a11aaf86859382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcfa3cd0e4b8e5c74b37888516651272f0367a2f8fbdcde05c0ec744e492ed55"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
