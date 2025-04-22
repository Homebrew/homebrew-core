class Litmusctl < Formula
  desc "Command-line interface for interacting with LitmusChaos"
  homepage "https://litmuschaos.io"
  url "https://github.com/litmuschaos/litmusctl/archive/refs/tags/1.15.0.tar.gz"
  sha256 "4814973152ccd3070159285c65cfef19ad185cbc2ac9a14cd58b9a474008d494"
  license "Apache-2.0"
  head "https://github.com/litmuschaos/litmusctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d243e765daeba1934f2fc20c785d1d32de4f599109deb03da0c58747ca971c90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d243e765daeba1934f2fc20c785d1d32de4f599109deb03da0c58747ca971c90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d243e765daeba1934f2fc20c785d1d32de4f599109deb03da0c58747ca971c90"
    sha256 cellar: :any_skip_relocation, sonoma:        "e532f7c2f9ddd18272a8f78f41cbf41ba57a27200b2e5ceb899d03ebb500c5fa"
    sha256 cellar: :any_skip_relocation, ventura:       "e532f7c2f9ddd18272a8f78f41cbf41ba57a27200b2e5ceb899d03ebb500c5fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e699fcb14e1e4ec9f2e0f1a84e96a2000d22c84e794723b74acd3854a739f1f"
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
