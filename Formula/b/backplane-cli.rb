class BackplaneCli < Formula
  desc "CLI for interacting with the OpenShift Backplane API"
  homepage "https://github.com/openshift/backplane-cli"
  url "https://github.com/openshift/backplane-cli/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "d414d40975c0c1d9eb493b5b67363a867ec70b39cde611d53a5722f4f4731896"
  license "Apache-2.0"
  head "https://github.com/openshift/backplane-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0afb0c39724fcf2e3f56fde7bbd4c1fddf6c7208f2d20fe2dcf8a762339ef521"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3fa8aa7ddc3fca29c2edc25f65cad119c1adb9935147a7bc2483eec58d98dd27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0aa28afc049c3ef41b0b0672296cbd1451b17916001e3cd3b8ee4f4752d2ab88"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e1fcdd77890ee88b999cb2333c12909af50eeb06e4e4d92c1e35aa3c537a5ffc"
    sha256 cellar: :any,                 x86_64_linux:      "005f7eb80002d57616e41574a3e44a57ec76f2e56213f032200e69f645a9767d"
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
