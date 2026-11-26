class Gcx < Formula
  desc "CLI for managing Grafana Cloud resources"
  homepage "https://github.com/grafana/gcx"
  url "https://github.com/grafana/gcx/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "a40ecede1c53ebc7b876456ea3d417cccc08b1adefb828f2587d7abb7402abc6"
  license "Apache-2.0"
  head "https://github.com/grafana/gcx.git", branch: "main"

  bottle do
    manifest_sha256 "b07ecd05a37f9951c66fe097762cec3fdb526cba0099b522e86deee9ae6e1048"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a7e20efc42d4145a95dbf6e479e0c11593e92e2f224e92d0633afbd0ae30f6ca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4d0d833b427ac149f04b405eb2b5fe53171ff9393736ebd1be0e4451c5358919"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d1edcb218ac81946b2de3a7e24fbaca655ebfad9f70dfc7b8a5be4268b856902"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7923095049ab66e4dfa8cfe5356ad1c7bf7cab0d1f8d21b9e7d0db2333454bdd"
    sha256 cellar: :any,                 x86_64_linux:      "5b0da408662f816c622b29c5cdbb7eed39d9da97e5b18fd38fe6c0262f0bd5a5"
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
