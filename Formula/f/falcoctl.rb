class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https://github.com/falcosecurity/falcoctl"
  url "https://github.com/falcosecurity/falcoctl/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "804a37e6372201ee21d3bc99ffea6079484b557ece0aa17719dbc6e8cb2b5fec"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/falcoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "556de5dbacdb8ac6708dd7cf9017e5957df4b983ad7cc97bc3d3aa1b6ca522f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f47f8fe1ee8709d72e272e3374063c106c380b0da60863b66d87bbcac6e30223"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92b2a574ae2bd39ef11432b45d269f235d436c1c60e3e6fbdd0e3f61f5b54f0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0286fbbbdcb0e4fb174ea755ab953f685766d076732011dec22486048c488588"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fc8c72cb28dca01251c12060f1d556f05e88ded378fe53b0f97863a9f9c44ef"
    sha256 cellar: :any,                 x86_64_linux:  "4752b2c4136105e3be9bf7601b8793bcaa0be19006ca5d53286f50b8376ad870"
  end

  depends_on "go" => :build

  def install
    pkg = "github.com/falcosecurity/falcoctl/cmd/version"
    ldflags = %W[
      -s -w
      -X #{pkg}.buildDate=#{time.iso8601}
      -X #{pkg}.gitCommit=#{tap.user}
      -X #{pkg}.semVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"falcoctl", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"index.yaml").write <<~YAML
      - name: test-artifact
        type: rulesfile
        registry: ghcr.io
        repository: falcosecurity/rules/falco-rules
    YAML

    config = testpath/"falcoctl.yaml"
    system bin/"falcoctl", "index", "add", "myindex", "file://#{testpath}/index.yaml", "--config", config
    assert_match "myindex", shell_output("#{bin}/falcoctl index list --config #{config}")

    assert_match version.to_s, shell_output("#{bin}/falcoctl version")
  end
end
