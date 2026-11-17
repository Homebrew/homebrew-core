class Gcx < Formula
  desc "CLI for managing Grafana Cloud resources"
  homepage "https://github.com/grafana/gcx"
  url "https://github.com/grafana/gcx/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "fc9ff8a6c3d010d1f6529ebb83eab57d6a81745e76caa5cdb0bbf4c633a07008"
  license "Apache-2.0"
  head "https://github.com/grafana/gcx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8c45e0349ddc49211bfe3631922922f47f2a03a23962fefab775936196e3d81a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6d6509d4d814c6b5c5efd7c57ec6c3483c9596f10cd6ad943e180f4375aad313"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "46cb6800f0f98d7ffb1c6edc757cf05a2f9f993e514723f04c15ac46935c9daa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9f6205269263703289daa321588b9f8ac4c1e12ba278f6b86cfe9984b14f78b7"
    sha256 cellar: :any,                 x86_64_linux:      "16e9789dcc87cd2861fd3e112f170b48aad569ed1f1e3bf87fcb568b286f6a4b"
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
