class OktaAwsCli < Formula
  desc "Okta federated identity for AWS CLI"
  homepage "https://github.com/okta/okta-aws-cli"
  url "https://github.com/okta/okta-aws-cli/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "e1d35e3007bac39fbedc436475712fca03706429bd34a1cfad4bdbd004bab81a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "591a478cbd614c61a339df5d2c878bbbc0fcbfa9741e504af62e8bd25fe66b4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d15afe899fd53be246196256e2bb0e82b1e26a59fc302e9c947b31f1c1da1f99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "864fa9aa2638ba1f9eb1b691468b83e944ed9f5d26bd9443c253c8da744576e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba16d61a221c06c264f70ecd99e5117d5a9caf0912efe5ce0b5cf594d9dd1951"
    sha256 cellar: :any_skip_relocation, ventura:        "62ee7c6980c206a4484814495c892542f2dbdbcedb5041a31d5482655e6d303d"
    sha256 cellar: :any_skip_relocation, monterey:       "40d2da6341ccb68ea1c6d6f8da088e8766022cad2c893ce156cb671b5e08d1ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bf5b2a0e519e879ef90a5f9131717a3dbec4d5bd94af23accf26f920831c102"
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
