class Litmusctl < Formula
  desc "Command-line interface for interacting with LitmusChaos"
  homepage "https://litmuschaos.io"
  url "https://github.com/litmuschaos/litmusctl/archive/refs/tags/1.20.0.tar.gz"
  sha256 "28c19c8a0354bc0611e3daffc7b94192ec9ef97386cf6244c85faf0e7792296d"
  license "Apache-2.0"
  head "https://github.com/litmuschaos/litmusctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ae48e3f2087014eda13621f55001227b982825767661e5583ed5c79625404ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ae48e3f2087014eda13621f55001227b982825767661e5583ed5c79625404ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ae48e3f2087014eda13621f55001227b982825767661e5583ed5c79625404ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f01891b09cf3d6abf3a6398282d8e88552fd75cf9f370c89b9f26ce45ffa04b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "440c997f4ebcffac3ea097225053c9bec259b06a7ca5c9183f91a6703f4baa4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ab1efd99cbbe07839f700a9ff7b9c50026e0c3262b6185531d43a0df18e50fb"
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
