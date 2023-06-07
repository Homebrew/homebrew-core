class OktaAwsCli < Formula
  desc "Okta federated identity for AWS CLI"
  homepage "https://github.com/okta/okta-aws-cli"
  url "https://github.com/okta/okta-aws-cli/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "c901b9221556e6ecf64a6ea20f7e6c43a4d629add306d9e4a03cd58c46f71912"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec32cc9e4af7d003a60f6a52edd771a9e75a3d6f937442f6ffd411876d8ab042"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec32cc9e4af7d003a60f6a52edd771a9e75a3d6f937442f6ffd411876d8ab042"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec32cc9e4af7d003a60f6a52edd771a9e75a3d6f937442f6ffd411876d8ab042"
    sha256 cellar: :any_skip_relocation, ventura:        "223457815c8b59c578dab2bb01264b668cc5d611549a53d4206881f110fe3b5a"
    sha256 cellar: :any_skip_relocation, monterey:       "223457815c8b59c578dab2bb01264b668cc5d611549a53d4206881f110fe3b5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "223457815c8b59c578dab2bb01264b668cc5d611549a53d4206881f110fe3b5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b132d83c017990a528ff0ac8ca6767a03e8cf286160bd7fb19d0f85b388ca15"
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
