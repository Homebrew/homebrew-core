class Litmusctl < Formula
  desc "Command-line interface for interacting with LitmusChaos"
  homepage "https://litmuschaos.io"
  url "https://github.com/litmuschaos/litmusctl/archive/refs/tags/1.14.0.tar.gz"
  sha256 "a1cf50378e83cd256e96157fe86dbe3cd6ba8a5084606b90b765d17c74545ca3"
  license "Apache-2.0"
  head "https://github.com/litmuschaos/litmusctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90fb9bef26fbb9806799163a424df6b782a3a2a6aabe25fecd46f1e71dc56bf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90fb9bef26fbb9806799163a424df6b782a3a2a6aabe25fecd46f1e71dc56bf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90fb9bef26fbb9806799163a424df6b782a3a2a6aabe25fecd46f1e71dc56bf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "08ce60980771acf45114ad7638bf71362ab6915aac532cb558da91b404d0bae3"
    sha256 cellar: :any_skip_relocation, ventura:       "08ce60980771acf45114ad7638bf71362ab6915aac532cb558da91b404d0bae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56e20b89e4d92a491e12404ece0a0726f9fa5afd0e4741923473c2e8b1aed3fe"
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
