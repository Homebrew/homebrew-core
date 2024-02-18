class OktaAwsCli < Formula
  desc "Okta federated identity for AWS CLI"
  homepage "https://github.com/okta/okta-aws-cli"
  url "https://github.com/okta/okta-aws-cli/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "1a216926c31c87e29c34edf82d1b2c317122d887c11c06d964b718fc4b9ec931"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1204912ceb25962215289b79c4ec1677b65aa71eefabcd230e5b0361bcea1684"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3837c159893d91a1c67b93f9cc215bfb9dccef533707dda9d7d7cac7ac514655"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae7e61f00ba9f6527e5fb5e11f3f2cb74a145890753ceeb4d4534d92d82de210"
    sha256 cellar: :any_skip_relocation, sonoma:         "22a600956f1ae24e3cb30bcdf4e9e94823ea32141fade2d00033c83c7a94edf8"
    sha256 cellar: :any_skip_relocation, ventura:        "dea2abc9644ce6a0cdb1eacd67f6d6198d618489a3981e386a1991f15aacacd3"
    sha256 cellar: :any_skip_relocation, monterey:       "204f9229aa9accee357ccad577d85786923e41c4cf9c881ad8d6b2c547888b48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "874cc5f2b7d0bbfb18480ebbcf5a670cb79375c26e02a7a4a74ed314689d42d0"
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
