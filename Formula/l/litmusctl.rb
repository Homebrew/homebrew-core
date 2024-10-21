class Litmusctl < Formula
  desc "Command-line interface for interacting with LitmusChaos"
  homepage "https://litmuschaos.io"
  url "https://github.com/litmuschaos/litmusctl/archive/refs/tags/1.11.0.tar.gz"
  sha256 "b982343f69196071df3cad8ad20a0397d3e64edb424d2d77b6b8f7b050e3ab6e"
  license "Apache-2.0"
  head "https://github.com/litmuschaos/litmusctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f7b88154fbee3d2fe381914d658b4d5ff8a994d9cd7bd4a57e076089db4dad7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f7b88154fbee3d2fe381914d658b4d5ff8a994d9cd7bd4a57e076089db4dad7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f7b88154fbee3d2fe381914d658b4d5ff8a994d9cd7bd4a57e076089db4dad7"
    sha256 cellar: :any_skip_relocation, sonoma:        "0eb826d0b2be3ef79885e6073a39238f25f58b697ab863bd7dc395e64e6fef25"
    sha256 cellar: :any_skip_relocation, ventura:       "0eb826d0b2be3ef79885e6073a39238f25f58b697ab863bd7dc395e64e6fef25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44ffb4fcda2e41f5c5d8b68443bc83fbce68b56a7cf5cc085d5b77d0f6bbb82a"
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
