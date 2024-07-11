class Litmusctl < Formula
  desc "Command-line interface for interacting with LitmusChaos"
  homepage "https://litmuschaos.io"
  url "https://github.com/shivam-Purohit/litmusctl/archive/refs/tags/1.8.0.tar.gz"
  sha256 "8bbd7e41ddd420140ef17dabb693acb3a28f48e8e4e9459a957302b6d2a158db"
  license "Apache-2.0"
  head "https://github.com/litmuschaos/litmusctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "759b8b912e12e56367809c1389a1dc42ecb996e0818b8d48c78230eece199204"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3429e1e9b9afa4351ba6faa7febef4e975428c463acc980e13b9dc45a6aff8ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27d38278f443c4b1303540c00d1330d00d6259b1af252748c519a64637fccd9c"
    sha256 cellar: :any_skip_relocation, sonoma:         "73e32f9caa7682739a9fb3fdc1a0dfcc8a0ea34df11e4c97420f8816c0de8e3a"
    sha256 cellar: :any_skip_relocation, ventura:        "157525e079c48a6d21dfc2c8b5883f3dec051ee278114b35955080298e7a4110"
    sha256 cellar: :any_skip_relocation, monterey:       "8172c13924467095707c294abbad0eb260a34d42dade14ec16943ecbe040037f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de011d67530d9dab5447c26000c1ec84cc27e6a922fa3ae1da8389b1ff8def9d"
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
