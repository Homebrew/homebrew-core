class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "af70b13c9a5d961b76fe6ad8ee85a05bbff6d9f8153cdaa1656d8455c33b2a8e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6ff09b49f4b12af902436cda668c382fd0fd96c077d035c72f76101be92df058"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "676fda85308ee56df2ec2d8e26aa43ef63890a7eb0c017ac2e21962ad7c1c051"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dbc23c13f9b44ebdc16675a91be6c5d53dab81656485b789b62eeaec3fc82046"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7e7697a08d561eb709f176708d46cca345f8bb7b68662b442ed7cfd2cdcd2828"
    sha256 cellar: :any,                 x86_64_linux:      "d894a2e3894f24534f8bc4470ad621a442942cede91dec3b4728ba82c4cea87c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/warpstreamlabs/bento/internal/cli.Version=#{version} -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bento"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bento --version")

    (testpath/"config.yaml").write <<~YAML
      input:
        stdin: {}#{" "}

      pipeline:
        processors:
          - mapping: root = content().uppercase()

      output:
        stdout: {}
    YAML

    assert_match "FOOBAR", pipe_output("#{bin}/bento -c #{testpath}/config.yaml", "foobar", 0)
  end
end
