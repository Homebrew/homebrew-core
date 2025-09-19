class Litmusctl < Formula
  desc "Command-line interface for interacting with LitmusChaos"
  homepage "https://litmuschaos.io"
  url "https://github.com/litmuschaos/litmusctl/archive/refs/tags/1.18.0.tar.gz"
  sha256 "f44649f75559bac43ffc8a0fe7ab35b6edab03ee448d8be0414c3b9934af8025"
  license "Apache-2.0"
  head "https://github.com/litmuschaos/litmusctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09bd1409cf724118f82f9cd2424ed81f0eff4289ad53c00981888c3aa7003c2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09bd1409cf724118f82f9cd2424ed81f0eff4289ad53c00981888c3aa7003c2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09bd1409cf724118f82f9cd2424ed81f0eff4289ad53c00981888c3aa7003c2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "98ce747b4545b195b910a15cfff891509578dda17cf23fbec71f9255281aff6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "493eebf6ac5f4787ff4dda254964755216a747d09d622e27c9b295d8e26a0eae"
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
