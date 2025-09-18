class Litmusctl < Formula
  desc "Command-line interface for interacting with LitmusChaos"
  homepage "https://litmuschaos.io"
  url "https://github.com/litmuschaos/litmusctl/archive/refs/tags/1.17.0.tar.gz"
  sha256 "0f4564974cbceff9f057b534f3a98640248dddaffce4d8b1f47368724200aaec"
  license "Apache-2.0"
  head "https://github.com/litmuschaos/litmusctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23e9fd08c30654701c9c46a2e1d7acf29e275b409b376ccb1d06666edff1f89c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48c16a91d4c8530c30968f5dd831988982100c49a059307c356b7f6c6d5cc3e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48c16a91d4c8530c30968f5dd831988982100c49a059307c356b7f6c6d5cc3e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48c16a91d4c8530c30968f5dd831988982100c49a059307c356b7f6c6d5cc3e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9c8e0a8ad0af7eaa9d0449268fa15d70f98b6d55f8570ddb00f1013660dd75e"
    sha256 cellar: :any_skip_relocation, ventura:       "d9c8e0a8ad0af7eaa9d0449268fa15d70f98b6d55f8570ddb00f1013660dd75e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc84c0da1f6d6fec5f431650c738230632126a35c5af9ec10b4d61ad723b7306"
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
