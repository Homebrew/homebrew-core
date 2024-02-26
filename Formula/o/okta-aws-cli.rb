class OktaAwsCli < Formula
  desc "Okta federated identity for AWS CLI"
  homepage "https://github.com/okta/okta-aws-cli"
  url "https://github.com/okta/okta-aws-cli/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "fb63138702a814115e382bfc2bc56cc903042a504b6a79aedabda9ea24c5c197"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d3a157906842e507b256c5370b730039d09502b42760867d0a29427d9c7e718e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8de9be347686c4d524c23cd814800283fb8762020abaf9078b2778f55737a829"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2542a0820f102d0c26cf079da99d20ce92afbbb30191e834e4de22df9ab496f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "46f0abb54ea83beb709e0a155a454481e3551733eaa90382fb4f3b2e5dd8b971"
    sha256 cellar: :any_skip_relocation, ventura:        "6d8a039cd331d43b9d3392f9da53ac5efe3b77aee1970011cfb209a38c6fe041"
    sha256 cellar: :any_skip_relocation, monterey:       "1b2af700efe9e186932877a49bc837bf5aa9437c980510cc028e00bc4488eb0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48044b6666966a34c7a2f6a3c0c70d5540c1687e31e8ad0d88ea2ba861c0e317"
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
