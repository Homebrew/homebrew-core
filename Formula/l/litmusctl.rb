class Litmusctl < Formula
  desc "Command-line interface for interacting with LitmusChaos"
  homepage "https://litmuschaos.io"
  url "https://github.com/litmuschaos/litmusctl/archive/refs/tags/1.16.0.tar.gz"
  sha256 "a40a42b86372a2b120ee7b8e8e49e3e8b7e36143869927f02b8ce61ac61c6c01"
  license "Apache-2.0"
  head "https://github.com/litmuschaos/litmusctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c63cc698f7a3ef948521ee5cb57a74153d35571f94c44f75eb4d95d8cf438607"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c63cc698f7a3ef948521ee5cb57a74153d35571f94c44f75eb4d95d8cf438607"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c63cc698f7a3ef948521ee5cb57a74153d35571f94c44f75eb4d95d8cf438607"
    sha256 cellar: :any_skip_relocation, sonoma:        "a996aa012c166cc2841874592ee4429a04f90add1c87f7b0cf44fe9a4f009140"
    sha256 cellar: :any_skip_relocation, ventura:       "a996aa012c166cc2841874592ee4429a04f90add1c87f7b0cf44fe9a4f009140"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7eef6f5ea0a7f0fc40a293dc72c6e9501083311672abc1d10f47d448ec65a2a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.CLIVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"litmusctl", "completion")
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
