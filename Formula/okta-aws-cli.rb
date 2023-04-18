class OktaAwsCli < Formula
  desc "Okta federated identity for AWS CLI"
  homepage "https://github.com/okta/okta-aws-cli"
  url "https://github.com/okta/okta-aws-cli/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "6a211818dcf544967516255f6ddf5599dbfb23437226c8b4db306d9e492a2881"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e08ae59b8ca9d28faa6bc03a861b42686d8bc41c3970561318cfbd5dd4077f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e08ae59b8ca9d28faa6bc03a861b42686d8bc41c3970561318cfbd5dd4077f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e08ae59b8ca9d28faa6bc03a861b42686d8bc41c3970561318cfbd5dd4077f7"
    sha256 cellar: :any_skip_relocation, ventura:        "9da5fccc79e00382dc87366e9d1c0b6756ee23f36bdddd33c4dcc8c4764bf053"
    sha256 cellar: :any_skip_relocation, monterey:       "9da5fccc79e00382dc87366e9d1c0b6756ee23f36bdddd33c4dcc8c4764bf053"
    sha256 cellar: :any_skip_relocation, big_sur:        "9da5fccc79e00382dc87366e9d1c0b6756ee23f36bdddd33c4dcc8c4764bf053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4635e7c7d100521b8276c1d4aea23ee9c08dc1271ef9342165b4dca2b2a44cd9"
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
