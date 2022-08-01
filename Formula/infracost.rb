class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.8.tar.gz"
  sha256 "e431beab103d6e011f5b32b5e67d76580051986c539e0d8ce0b2ea1a4984e320"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29010f1a95af277d0ffa803ff1724eba9820dc85ed60d388e6a8d707a2f1ab00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2fab4e6899368343029a7e0dcc71304cb01bed4429198fe8ab2872bbdec57e91"
    sha256 cellar: :any_skip_relocation, monterey:       "33f22209851ee0aeaf235704f4be702f40b344ef662f6dedc1a58b14de050a2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ada4283726b8fcc22a426510c90a1f92548516a0c64bac60cee1e9f6c27a257a"
    sha256 cellar: :any_skip_relocation, catalina:       "14b26581cb0117096ba631987f9e1ee1a966ce6d5bc848c21c491cee75c45359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86daf207a837874aa3bf8142c7c9ccbd8304f2e52929085c144137ea698c2b2d"
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
