class OktaAwsCli < Formula
  desc "Okta federated identity for AWS CLI"
  homepage "https://github.com/okta/okta-aws-cli"
  url "https://github.com/okta/okta-aws-cli/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "f617b105e885fc8dc53accd7f3f8a2c3165b28b52abfbe7151e8353ad7eb427b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09e8f3a5844c9ed873d26882f252ecb0aecdd9a26e1db5808016561de842314b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8e9895b27c279036cdd3dd86e0575dca69383dc4989b0d65b74ea7f074f7877"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "595bd50888896385ef6bef657ae3d34fa01fc677d6b4c03180d20d70b1215cfa"
    sha256 cellar: :any_skip_relocation, ventura:        "49f51303fb12d58e7e3e43819c06a433686cfa65a7a6a223c1f76bf1ca48f9bc"
    sha256 cellar: :any_skip_relocation, monterey:       "0b6af37bc468cca4781846501d4eff8b23fdaab56e0be4acc9281218c0e627fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8da19e76a30cf113bc1002a21f58a86e83e593a7bd2f127d6ddce4f306a6343"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bba97643b58fc351e51b8ca759e6b5fd76a12d9c2c2f5fba2b3b5e83e0ade055"
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
