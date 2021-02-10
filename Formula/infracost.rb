class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.7.18.tar.gz"
  sha256 "92886a5587a576352ed634064e52f3e35c5d84d22bb5a814db54897935d9986e"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "053c8fee97ba606c8d46d5f386dac4db18ced4b74a3437ee17db750cdb6bc5c8"
    sha256 cellar: :any_skip_relocation, big_sur:       "64e6870cd37593860ba98e42ad7484a1d46997657407967163bda728acd9b179"
    sha256 cellar: :any_skip_relocation, catalina:      "2947f2af805d7b2995d90a8932618b77d743911d7e83dc657a4a46845ac9b4c2"
    sha256 cellar: :any_skip_relocation, mojave:        "82298737811c088937de5a97203bfe5e1e374fdd732134e8d7ffa5aceee83118"
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
