class Gcx < Formula
  desc "CLI for managing Grafana Cloud resources"
  homepage "https://github.com/grafana/gcx"
  url "https://github.com/grafana/gcx/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "8d3fb5c11e9e6ae19b5925a70fe4a0f4c6c75d54424e16525d2c4dc7c3f183ea"
  license "Apache-2.0"
  head "https://github.com/grafana/gcx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2141d902bfd010bfbf7461033f3625b0df1d501fac091ce0be9d6155226b8355"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "42a5183c1880c40eef115330ac75a03208fd64e9e28f2ce3212d5c7f17fc4d8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4c19edccde756df6995e05277ecc7c13ae79627243c5ce9cb1c28bdacb2a98a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2b2eab3a362c0ff2e67de1f7a95ccf2a533507e1e4459f457cef7b5e3a28bf3b"
    sha256 cellar: :any,                 x86_64_linux:      "1286b78dc6805c9f8abd4d0564dc19ffc937f934af8461113e1850afc5e189c5"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/gcx"

    generate_completions_from_executable(bin/"gcx", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gcx --version")

    system bin/"gcx", "config", "set", "stacks.test.grafana.server", "https://grafana.example.net"
    assert_match "https://grafana.example.net", shell_output("#{bin}/gcx config view")

    assert_match "Unknown output format", shell_output("#{bin}/gcx commands --output bogus 2>&1", 1)
  end
end
