class OktaAwsCli < Formula
  desc "Okta federated identity for AWS CLI"
  homepage "https://github.com/okta/okta-aws-cli"
  url "https://github.com/okta/okta-aws-cli/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "c778ffa6457084a3b3b224782690db5e05d1c8a797cfff0b12002f80f5ffc3dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa5c34ab73ad9c8734a6980b1a43f8bc0a6f1f6dcda6a71fdb33ea4b881780eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa5c34ab73ad9c8734a6980b1a43f8bc0a6f1f6dcda6a71fdb33ea4b881780eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa5c34ab73ad9c8734a6980b1a43f8bc0a6f1f6dcda6a71fdb33ea4b881780eb"
    sha256 cellar: :any_skip_relocation, ventura:        "bf8d27d3a033b811992dc3a606a7f5a7fcbfaf356aa91c664fde353876f38e97"
    sha256 cellar: :any_skip_relocation, monterey:       "bf8d27d3a033b811992dc3a606a7f5a7fcbfaf356aa91c664fde353876f38e97"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf8d27d3a033b811992dc3a606a7f5a7fcbfaf356aa91c664fde353876f38e97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7059cfa0394ba5980e2e70c7576725ea5e8eeb7e4d4b20660944152436535e9d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/okta-aws-cli"
  end

  test do
    str_help = shell_output("#{bin}/okta-aws-cli --help")
    assert_match "Usage:", str_help
    assert_match "Flags:", str_help
    str_error = shell_output("#{bin}/okta-aws-cli -o example.org -c homebrew-test 2>&1", 1)
    assert_match 'Error: authorize received API response "404 Not Found"', str_error
  end
end
