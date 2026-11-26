class Gcx < Formula
  desc "CLI for managing Grafana Cloud resources"
  homepage "https://github.com/grafana/gcx"
  url "https://github.com/grafana/gcx/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "a40ecede1c53ebc7b876456ea3d417cccc08b1adefb828f2587d7abb7402abc6"
  license "Apache-2.0"
  head "https://github.com/grafana/gcx.git", branch: "main"

  bottle do
    manifest_sha256 "3f467de019cf7fb221e1bb0d02caecc7aabeeb8e0666e7bfcd0768916ac6ee90"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ca979433d465b22e5627c157b2a347514eb74064692908310c6d386bd2a45e8b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a847046488420b803eb018eb605ae1b93211b1e38b10d7e3c1361bc22299b84d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b84beb591f5a8e47acdf10759f35cb8235fd61c76196ab21e9a3fcec3f63ef31"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a52f9e9ec772efed6b76c563df823d59e5d97498aadc6e5ea5e5bd17ef395f71"
    sha256 cellar: :any,                 x86_64_linux:      "f14960bda5105e9dc40b042c08dd8f79a7f38e0e7cb34f124cfdb8143a2f2177"
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

    assert_match "unknown output format", shell_output("#{bin}/gcx commands --output bogus 2>&1", 1)
  end
end
