class Litmusctl < Formula
  desc "Command-line interface for interacting with LitmusChaos"
  homepage "https://litmuschaos.io"
  url "https://github.com/litmuschaos/litmusctl/archive/refs/tags/1.24.0.tar.gz"
  sha256 "d0d36d9a0140e2406485e18988434c08f709f14453425df575096d34e9911344"
  license "Apache-2.0"
  head "https://github.com/litmuschaos/litmusctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4044f997fde24e21457ddd43a2cdb0536747a1fd293b03a0e220252b57809fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4044f997fde24e21457ddd43a2cdb0536747a1fd293b03a0e220252b57809fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4044f997fde24e21457ddd43a2cdb0536747a1fd293b03a0e220252b57809fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "37d12cb311c7297f38e9e56e3f324275de3e3686de32f1281ce0e880b7d9d10d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2eda5f6c17e29018559fd66c36915ff143035f413f2aa058b0fa4dbfda17620b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b655dd642abe77aa63e4e9a20de78df2326e4b0cb37bc55b08173ac9318f44e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.CLIVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"litmusctl", shell_parameter_format: :cobra)
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
