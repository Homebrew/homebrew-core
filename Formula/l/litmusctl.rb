class Litmusctl < Formula
  desc "Command-line interface for interacting with LitmusChaos"
  homepage "https://litmuschaos.io"
  url "https://github.com/litmuschaos/litmusctl/archive/refs/tags/1.9.0.tar.gz"
  sha256 "f1f60eb73eaa1a3627fb2b77422d76f767cbc81783fa18e191a15f48f2ce1513"
  license "Apache-2.0"
  head "https://github.com/litmuschaos/litmusctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ce49aff5838d6f7fec4ed299b041e0433bd66c6accb891b5d2b79c81123ed3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f7326ef52702108ccdbcd6ebeed0a54b88ffb553ea5cc0aafb251b68126315c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a2ba395a7a41eeae29454b6800a4503739a76429f616176169f7fb6144149ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "c17b58694f23c580271f18527eee7594f60407b02e95532f8448d262d76e39e1"
    sha256 cellar: :any_skip_relocation, ventura:        "b48fd8db2e3e316cf74cbc41e535f9a3f51375ec3d5f760c8cd6d8ff5390c279"
    sha256 cellar: :any_skip_relocation, monterey:       "e17666047fff029e4b29d3ef0cf7289915bbbc64f2a447f03cb09dd49cde0981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4858bac81a996125ab069c2794a9de8da61085ea50c85dc52bc151b3f21152dd"
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
