class Litmusctl < Formula
  desc "Command-line interface for interacting with LitmusChaos"
  homepage "https://litmuschaos.io"
  url "https://github.com/litmuschaos/litmusctl/archive/refs/tags/1.28.0.tar.gz"
  sha256 "cb165985c5b0756c7eb1d5a8a2f8d94fb2efb943b05b5e003a7e1621850e87fa"
  license "Apache-2.0"
  head "https://github.com/litmuschaos/litmusctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6d79030bd5dd8f034c4806cff51d6c3617ee88e8455328fc2545c319d0607d2f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6d79030bd5dd8f034c4806cff51d6c3617ee88e8455328fc2545c319d0607d2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6d79030bd5dd8f034c4806cff51d6c3617ee88e8455328fc2545c319d0607d2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f4af354a6d97e65ae3197b8423d6491edacbc31c3e63f274b0ae36f9b9090905"
    sha256 cellar: :any,                 x86_64_linux:      "56e79717f250d666f57af6fc8b8ef8c2beca356813c29cfdcf66b7f5bd41c3f9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.CLIVersion=#{version}")

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
