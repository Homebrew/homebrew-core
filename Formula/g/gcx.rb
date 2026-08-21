class Gcx < Formula
  desc "CLI for managing Grafana Cloud resources"
  homepage "https://github.com/grafana/gcx"
  url "https://github.com/grafana/gcx/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "08ac57cbde273f0ca929e7ca32a90f0319a2dc65a961b637135331a28ce65887"
  license "Apache-2.0"
  head "https://github.com/grafana/gcx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3eb46707f04f314439830a79c04fc70a8acebda0c33514f98c8691f074195652"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dd3ba73bf80a78c55c31436c27e797a33d19ff07422c591aa0ba00de4fb5f1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcf27da049d00dc81431063ead8df7599a98ac56023d26f4613538fc07d5641c"
    sha256 cellar: :any_skip_relocation, sonoma:        "82c4cf7c0a186dc21594b654ebdacb395c10dac04e9a6f033f3dc4f609952f83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d16418833a63a799849cdc88b22281c9698fa3afe3388762b3d64520c9d37829"
    sha256 cellar: :any,                 x86_64_linux:  "b2135b167a0ddc7ba9b3959fc13fe42390604e5b1f9873c977c18262b6176a60"
  end

  depends_on "go" => :build

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
