class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.7.tar.gz"
  sha256 "81cc2711db13185f31fec2dfad56b61842c39195127a47fccc589e879bf59f13"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0aea17dffb3317c72a3768c939a974677109d253e8e2b5ed05a6ac90db65cace"
    sha256 cellar: :any_skip_relocation, big_sur:       "dee74552abc86d39a1d5c05d967631439ef829c5820165f1643b32399b1dfb2f"
    sha256 cellar: :any_skip_relocation, catalina:      "dee74552abc86d39a1d5c05d967631439ef829c5820165f1643b32399b1dfb2f"
    sha256 cellar: :any_skip_relocation, mojave:        "dee74552abc86d39a1d5c05d967631439ef829c5820165f1643b32399b1dfb2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63ce52d7697e73b79d4f024b6b6d502e351e3ef28391994f9648cbc7800adbbf"
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
