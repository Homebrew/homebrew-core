class Gcx < Formula
  desc "CLI for managing Grafana Cloud resources"
  homepage "https://github.com/grafana/gcx"
  url "https://github.com/grafana/gcx/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "67d80291d3305366495aa2f60cf7f3f9b673f029dc123a7e45c4871ae4c2ff1f"
  license "Apache-2.0"
  head "https://github.com/grafana/gcx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26d450039eadcec286669698428aef850a97d175b64363fb7b5767d1719c2dc5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48297f42aaa3600fe32d537f9caa7c3d43a735dc8bae5e7910d8077e5fb6d100"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db3e67f5e63f9afeff9035b1fd4f13085f8062563cd92fea0d79888444f020d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcd820bd55229cc1ae00dd1be3cd9d52ad7a22fe94f7b3adddf34474e9f3d76e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f64b27ced7eedabaa41d3b29957829edb9531214b7de0b4e644475209e175512"
    sha256 cellar: :any,                 x86_64_linux:  "15c23b44442819a0e554ee8e8e777989d0be395869a1859892c93d714faa10fd"
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
