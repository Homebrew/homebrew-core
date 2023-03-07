class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.18.tar.gz"
  sha256 "62c963d044fbe5ad16d7df2b41cde6b820d7a57f9aa825aeb79ba1b9d437a06c"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5c0ba2cbdd9d47e0d3cc633effcf6fcc1e10f2a88aa993a7e7a59cce222f0ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5c0ba2cbdd9d47e0d3cc633effcf6fcc1e10f2a88aa993a7e7a59cce222f0ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5c0ba2cbdd9d47e0d3cc633effcf6fcc1e10f2a88aa993a7e7a59cce222f0ea"
    sha256 cellar: :any_skip_relocation, ventura:        "8f7878aec0308c72ebab4593b81cada87e2d5b837779958d00d25e06e305d141"
    sha256 cellar: :any_skip_relocation, monterey:       "93de1299f0821162cc6fab5ddb7e49921527bf3c64dd21d48406c5b020553464"
    sha256 cellar: :any_skip_relocation, big_sur:        "93de1299f0821162cc6fab5ddb7e49921527bf3c64dd21d48406c5b020553464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa34f19dcb876743682d09299feb5c5ccd678a6af557623e153b9cbe8f26225a"
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
