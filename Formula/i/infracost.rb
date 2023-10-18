class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.29.tar.gz"
  sha256 "d74e32dd75b132d27d3d42ce345caf020c6a6e7e061c72f479d52307bd21d691"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5dfaa8bc725cef6734500ab51fd8677275241199f0e766ca47baafbee7159a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5dfaa8bc725cef6734500ab51fd8677275241199f0e766ca47baafbee7159a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5dfaa8bc725cef6734500ab51fd8677275241199f0e766ca47baafbee7159a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "79a15f0053f7a1044f58391f4733101cc2de0756a276de19e4c0542f20b4d10a"
    sha256 cellar: :any_skip_relocation, ventura:        "79a15f0053f7a1044f58391f4733101cc2de0756a276de19e4c0542f20b4d10a"
    sha256 cellar: :any_skip_relocation, monterey:       "79a15f0053f7a1044f58391f4733101cc2de0756a276de19e4c0542f20b4d10a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32bcd13b9b9e3d59e6f87bd8c5ef7458e93368e1dfd84c0a0822e43562b72d5c"
  end

  depends_on "go" => :build

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
