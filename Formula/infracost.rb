class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.18.tar.gz"
  sha256 "e986edfd55af528b3710e569f3d44b9fae8436690daaf77d6959522fc4309235"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf3fa9c1d5f4f7e71505766be54f9eb4b0bb4fa71e6edb4bbab3d0972b057b37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf3fa9c1d5f4f7e71505766be54f9eb4b0bb4fa71e6edb4bbab3d0972b057b37"
    sha256 cellar: :any_skip_relocation, monterey:       "0be5afb4761e59d053056b157dca465f3433a93bd2878efcc215213597025ae1"
    sha256 cellar: :any_skip_relocation, big_sur:        "0be5afb4761e59d053056b157dca465f3433a93bd2878efcc215213597025ae1"
    sha256 cellar: :any_skip_relocation, catalina:       "0be5afb4761e59d053056b157dca465f3433a93bd2878efcc215213597025ae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75289bf92b12d62aee4d6f6465a09a012e41d20d20b965c7b0d4741daf149381"
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
