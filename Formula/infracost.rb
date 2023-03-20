class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.18.tar.gz"
  sha256 "62c963d044fbe5ad16d7df2b41cde6b820d7a57f9aa825aeb79ba1b9d437a06c"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "939679d0c7f94e78b92412f000cd467cb5451ab47d228f6e2d9ed258d6a1b142"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "939679d0c7f94e78b92412f000cd467cb5451ab47d228f6e2d9ed258d6a1b142"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "939679d0c7f94e78b92412f000cd467cb5451ab47d228f6e2d9ed258d6a1b142"
    sha256 cellar: :any_skip_relocation, ventura:        "ac5d5552f51709fe51d6a350cc9bb278221726979d8f551c4a6115eb0988d27c"
    sha256 cellar: :any_skip_relocation, monterey:       "ac5d5552f51709fe51d6a350cc9bb278221726979d8f551c4a6115eb0988d27c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac5d5552f51709fe51d6a350cc9bb278221726979d8f551c4a6115eb0988d27c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46a55c19fe4c6aea83b3cc5c3bc6d5d962047111eee8531e681a0e5b97299512"
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
