class Litmusctl < Formula
  desc "Command-line interface for interacting with LitmusChaos"
  homepage "https://litmuschaos.io"
  url "https://github.com/litmuschaos/litmusctl/archive/refs/tags/1.26.0.tar.gz"
  sha256 "6f38b7d186dbf2553bef95756fc70a994ed7b30c5a844c71ddea7124402234c3"
  license "Apache-2.0"
  head "https://github.com/litmuschaos/litmusctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fcf07e12f209ae9d141fe2c8c147b512a03cf938fc06bfd1eba1d1f431555fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fcf07e12f209ae9d141fe2c8c147b512a03cf938fc06bfd1eba1d1f431555fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fcf07e12f209ae9d141fe2c8c147b512a03cf938fc06bfd1eba1d1f431555fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2c98ddb505cc2856ca39763fc3f12ca4d48d3f8a7a625e46678cddecf05f5ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "579b8190610a8ac159b89cf380ccf7d130993ebacc54c852909c1ce2d32d70ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1087d3f1eac17f9b9c40ec62c34e30ab5ea5aace941be8f536841c1c870ec8a0"
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
