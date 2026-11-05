class BackplaneCli < Formula
  desc "CLI for interacting with the OpenShift Backplane API"
  homepage "https://github.com/openshift/backplane-cli"
  url "https://github.com/openshift/backplane-cli/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "d414d40975c0c1d9eb493b5b67363a867ec70b39cde611d53a5722f4f4731896"
  license "Apache-2.0"
  head "https://github.com/openshift/backplane-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bbfdcc5f6bd20189cd672c440260e8875ec530229e5f45414a8023255a788796"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "398647210e97e6118183c05410c302fce4f91e7afb5223108617278ae92abbd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4ea2db9005234db38970a9628fa8a286fd8ba6ca1d56fc78898e3e3f5d7df9a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0c19ea4b335d1d31710d7496896912d83c8369d19cb33a9a77fdb384c7e6168d"
    sha256 cellar: :any,                 x86_64_linux:      "0e7c5a1beee520c388c87ea472ecf26f6ea6d569da5d1cb85c1a060112fe62ef"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/openshift/backplane-cli/pkg/info.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"ocm-backplane"), "./cmd/ocm-backplane"
    generate_completions_from_executable(bin/"ocm-backplane", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocm-backplane version")

    # Verify config set persists to disk
    ENV["BACKPLANE_CONFIG"] = testpath/"config.json"
    system bin/"ocm-backplane", "config", "set", "url", "https://test.example.com"
    config_json = JSON.parse(File.read(testpath/"config.json"))
    assert_equal "https://test.example.com", config_json["url"]
  end
end
