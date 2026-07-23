class Litmusctl < Formula
  desc "Command-line interface for interacting with LitmusChaos"
  homepage "https://litmuschaos.io"
  url "https://github.com/litmuschaos/litmusctl/archive/refs/tags/1.27.0.tar.gz"
  sha256 "f1d1bb3ef96e0d6e9890ac2a6f84abce6995ec673440fe010866cc1d70f2c415"
  license "Apache-2.0"
  head "https://github.com/litmuschaos/litmusctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "650ef3bea5e3fa502eb0aab865a1198f1d553874b0fd2b8e40fc863f2d10ba34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "650ef3bea5e3fa502eb0aab865a1198f1d553874b0fd2b8e40fc863f2d10ba34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "650ef3bea5e3fa502eb0aab865a1198f1d553874b0fd2b8e40fc863f2d10ba34"
    sha256 cellar: :any_skip_relocation, sonoma:        "873478861b77c1bffa4f86b10e5816480dda1247556977f3eebdbe54fb4421c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e80e8a9c4a9201bcdedd769c95fc373049d9b781cdaf36998cbcefa5857efe0"
    sha256 cellar: :any,                 x86_64_linux:  "5e1754ad4c8d3bf8a1e43291caa025180c17112b51d4ea9f1a514d3ab255d9c7"
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
