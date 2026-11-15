class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https://github.com/falcosecurity/falcoctl"
  url "https://github.com/falcosecurity/falcoctl/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "c9cf5bc0959e282a178ef2adbf96eb42532a6bf47569f74a923411df334606ca"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/falcoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0744e56b024fb92e89925d4e10031dbbcd299cc28c253a6d67ca564daf76af69"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ffe85cfee40b9950209a31eea3b744d535553f51207df03186299816921aa21e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7387c8f93b980b48fc7b49792c0a8be9948ac963bc5069f314bd09ea26accb40"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ee336256998066832dfc6fa13e6cc95f1c8d5187b2233fea8c7caf7f005b6231"
    sha256 cellar: :any,                 x86_64_linux:      "89aa850b1f37e1fa129faac65a7efff9f4758c1769f7861360b3b02938c21254"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    pkg = "github.com/falcosecurity/falcoctl/cmd/version"
    ldflags = %W[
      -X #{pkg}.buildDate=#{time.iso8601}
      -X #{pkg}.gitCommit=#{tap.user}
      -X #{pkg}.semVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:)

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
