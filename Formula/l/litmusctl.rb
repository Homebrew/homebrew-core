class Litmusctl < Formula
  desc "Command-line interface for interacting with LitmusChaos"
  homepage "https://litmuschaos.io"
  url "https://github.com/litmuschaos/litmusctl/archive/refs/tags/1.7.0.tar.gz"
  sha256 "f4e404b645651e0923d38b1c56ce4a6643bda3bc27d881cddbd82ee6f7a8a7e0"
  license "Apache-2.0"

  head "https://github.com/litmuschaos/litmusctl.git", branch: "master"

  depends_on "go" => :build

  def install
    # Build the binary
    ldflags = %W[
      -s -w
      -X main.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # Test installation
    assert_match version.to_s, shell_output(bin/"litmusctl version")

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

    output_user = shell_output("#{bin}/litmusctl config use-account --endpoint 'something' --username 'something'", 1)
    assert_match "⛔ Account not exists", output_user
  end
end
