class Litmusctl < Formula
  desc "Command-line interface for interacting with LitmusChaos"
  homepage "https://litmuschaos.io"
  url "https://github.com/litmuschaos/litmusctl/archive/refs/tags/1.21.0.tar.gz"
  sha256 "40bab734aeb96c0bf75a05d3c020f65001c7aad3884fb93ac464317d9437cc19"
  license "Apache-2.0"
  head "https://github.com/litmuschaos/litmusctl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "425da5d7187636f89ed543fd2711daff5e95e6dcf5b3165443b6495377b1ef07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "425da5d7187636f89ed543fd2711daff5e95e6dcf5b3165443b6495377b1ef07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "425da5d7187636f89ed543fd2711daff5e95e6dcf5b3165443b6495377b1ef07"
    sha256 cellar: :any_skip_relocation, sonoma:        "be483e3a9e9640967109a6cc81df1b7793513468f4cf6c60c0312f79eb5c20b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18decd447c4ac8c6a1dbcf30670c50aa60082c9a8063747cdf2318a04b72786e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08ce81b1564cf969f27e3cfe3c644412e96e2a3bce9650f44b9b2b1144305956"
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
