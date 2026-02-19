class Litmusctl < Formula
  desc "Command-line interface for interacting with LitmusChaos"
  homepage "https://litmuschaos.io"
  url "https://github.com/litmuschaos/litmusctl/archive/refs/tags/1.22.0.tar.gz"
  sha256 "a1b8bc17d90337b0ef92b9088497970b540f5501dd8fbf7a2b4b8745d834e177"
  license "Apache-2.0"
  head "https://github.com/litmuschaos/litmusctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f8f6752d56ddc5049d21ecd34591201b30e4f75318323d273bfffabaa152533"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f8f6752d56ddc5049d21ecd34591201b30e4f75318323d273bfffabaa152533"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f8f6752d56ddc5049d21ecd34591201b30e4f75318323d273bfffabaa152533"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8171b1049328ec1d917000691bf7330dbea9613208e1267a73fea9dc53b5b5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dddec66f17a9dadd769096351fcd913d496ee6b5b21af66f09064d61242d48f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a04d97e5f07dfbd4aa0f75c5ee99d9e64e19cff634940353141f8dfe055e39d7"
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
