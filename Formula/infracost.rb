class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.2.tar.gz"
  sha256 "f007bafa8592e3c33ef430eed397964b13eeb3ab3b2b0ea33fe526c3f53ae944"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f50fb2936e9281ccca1dc3e71e17db7ba38abdc34661432c9c1d6c4075e45cf8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21672fdd0aa69bda534f83f909de21f4625830c95e7e514cae4b77260b1d3472"
    sha256 cellar: :any_skip_relocation, monterey:       "0b0e538a082993f86241ae7cc102b8dd80a9e30336bf00f029e1124693342a2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b0e538a082993f86241ae7cc102b8dd80a9e30336bf00f029e1124693342a2a"
    sha256 cellar: :any_skip_relocation, catalina:       "0b0e538a082993f86241ae7cc102b8dd80a9e30336bf00f029e1124693342a2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d9307315a00aea42bc9f940ad87f30f201e4ce5a8a50c75635d3e8c5e638690"
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
