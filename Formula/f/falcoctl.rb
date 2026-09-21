class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https://github.com/falcosecurity/falcoctl"
  url "https://github.com/falcosecurity/falcoctl/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "2ac3bd90913933e7fb6f9a722e1b8999dedaaab158c1ea073405d28c491112c1"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/falcoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "12f12bf7f8d762be10cd901a89f56abad7e6ff1e660e2e16faea814e2d15ed56"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f5a871b93c661294256750f84811e8cdb6b892514ffeb048d4a5a843887fdaef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4155396efebc714e73e314e11b5e47d2ccf983bba1bfebd0d68845cd0e77cae3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "16a482c1d2f4a10778c7fd7dfc21299e58d4cc90f4a290ec861a0b5211b32825"
    sha256 cellar: :any,                 x86_64_linux:      "60ed8e1240a2d4fc21ad09dc6dbdc3a92f01cd5a62ecc85d87ac889d3bc17cc3"
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
