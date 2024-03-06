class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/refs/tags/v0.10.34.tar.gz"
  sha256 "ee4a042ba813d9d3560e1c07cf35e983e5f6bcd6961a9d041c97db808478978d"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3235d65a66e41dfa32df531a221a9632c5c94082ccba9488518e69c377358dea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3235d65a66e41dfa32df531a221a9632c5c94082ccba9488518e69c377358dea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3235d65a66e41dfa32df531a221a9632c5c94082ccba9488518e69c377358dea"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b90bd7b842fe4234712cb9e523597a2dd12a4e1758e6605b274457591f93fbf"
    sha256 cellar: :any_skip_relocation, ventura:        "2b90bd7b842fe4234712cb9e523597a2dd12a4e1758e6605b274457591f93fbf"
    sha256 cellar: :any_skip_relocation, monterey:       "2b90bd7b842fe4234712cb9e523597a2dd12a4e1758e6605b274457591f93fbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0a631026d2cffda264888355742b627e586930ff7014ef06ed99e7ee70133cf"
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
    assert_match "Error: INFRACOST_API_KEY is not set but is required", output
  end
end
