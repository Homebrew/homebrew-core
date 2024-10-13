class Litmusctl < Formula
  desc "Command-line interface for interacting with LitmusChaos"
  homepage "https://litmuschaos.io"
  url "https://github.com/litmuschaos/litmusctl/archive/refs/tags/1.10.0.tar.gz"
  sha256 "fb6f987c36dd9f297cab50ccde20449ac0f6539c682901a1ea3c1a8decb63426"
  license "Apache-2.0"
  head "https://github.com/litmuschaos/litmusctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fbc495d09718782ef1f7b457ed1c354ea083ea9ecc74a71a5bc896ea393cbc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fbc495d09718782ef1f7b457ed1c354ea083ea9ecc74a71a5bc896ea393cbc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5fbc495d09718782ef1f7b457ed1c354ea083ea9ecc74a71a5bc896ea393cbc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b551cee364d23ddc4939a876df69201b1528570bc1ffc364c302a8676d6d9cd9"
    sha256 cellar: :any_skip_relocation, ventura:       "b551cee364d23ddc4939a876df69201b1528570bc1ffc364c302a8676d6d9cd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "341dbe87a986d36a2bc6896bd2c4aab7a76efa1a4cb4e8a67c177fdaf7321ba4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.CLIVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/litmusctl version")

    # add the config file in the main directory
    (testpath/".litmusconfig").write <<~EOS
      accounts:
      - users:
        - expires_in: "1705404092"
          token: faketoken
          username: admin
        endpoint: testEndpoint:test
        serverEndpoint: testServerEndpoint:test
      apiVersion: v1
      current-account: http://192.168.49.2:30186
      current-user: admin
      kind: Config
    EOS

    output_endpoint = shell_output("#{bin}/litmusctl config get-accounts")
    assert_match "testEndpoint:test", output_endpoint

    output_user = shell_output("#{bin}/litmusctl config use-account --endpoint=something --username=something", 1)
    assert_match "Account not exists", output_user
  end
end
