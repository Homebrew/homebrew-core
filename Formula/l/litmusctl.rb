class Litmusctl < Formula
  desc "Command-line interface for interacting with LitmusChaos"
  homepage "https://litmuschaos.io"
  url "https://github.com/litmuschaos/litmusctl/archive/refs/tags/1.25.0.tar.gz"
  sha256 "b96cb0e191bb92d6ab92761e959fa39de0af0fc3e33de4b2bedd2b4c9606cfe1"
  license "Apache-2.0"
  head "https://github.com/litmuschaos/litmusctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f687453f4c2be4192c6e643ab646f471e860e148187d13461f457e437fdbf99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f687453f4c2be4192c6e643ab646f471e860e148187d13461f457e437fdbf99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f687453f4c2be4192c6e643ab646f471e860e148187d13461f457e437fdbf99"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a914a469d558e93682951a394648c8f315b1313c55563de0c3af6166723c6e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80202429a75f88549981822b744933f007a5c37290591857569aa454a337f032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb75e9c63dddc9b32f1fc37b25dfc72c0114397a8ff0f2a72a9f5c2fc82f2775"
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
