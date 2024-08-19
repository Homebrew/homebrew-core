class OktaAwsCli < Formula
  desc "Okta federated identity for AWS CLI"
  homepage "https://github.com/okta/okta-aws-cli"
  url "https://github.com/okta/okta-aws-cli/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "e7ac241007f4a50b637ea2d0d15f3e1123245e3d874c16d7e5d8ab9812688830"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb1ff85e58451d525cca3ca8152b2dadc200aa99a5e2df6a70b32e39c87f2b99"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d936a6564befadda9bf8793e05658969881f4e4dabd38e917b084bcdde43592"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db077bcb308d1fb3021fbcf4fd6ee1827ee58a417d26d5a4366eb93c6a0046af"
    sha256 cellar: :any_skip_relocation, sonoma:         "afad45a170f43f23ce4dcde12bbdd01a558e54676eeddb9572729462a790afa0"
    sha256 cellar: :any_skip_relocation, ventura:        "48f83f54d1eabf63df14fc928350f8c5bd61cad76e90c3067234ebfe8b3ac084"
    sha256 cellar: :any_skip_relocation, monterey:       "d1fb5daf7393c52921fc170654703377826a8b4d709d5f580850858cf8760775"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c088637b703919fce732329aa233cdee9eefa8f7f238435d14f78967a46e363e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/okta-aws-cli"
  end

  test do
    output = shell_output("#{bin}/okta-aws-cli list-profiles")
    assert_match "Profiles:", output

    assert_match version.to_s, shell_output("#{bin}/okta-aws-cli --version")
  end
end
