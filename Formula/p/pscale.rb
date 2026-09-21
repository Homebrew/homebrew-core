class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.338.0.tar.gz"
  sha256 "32ab6b5464e22ce3e1ef40f99386c22e966d756bc70a2e4962114e6c7270bfd0"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "15a076e643d013e18ce6054fd139bc8bcb6b832148a69c5239833c8e6598ad7f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a4882d755b484e6c172a09e3ba5e6a0727d89befa42e3b5d4a33a5df8e6df062"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9190fa1e13ade4b5dd51f7abb0697d26033efe1f2b4341e4a11e8c6aa4ae6623"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d9ebb1aeaca61ce32ec687ab8903cf13b1365c552329f5123a65821aa1b47b74"
    sha256 cellar: :any,                 x86_64_linux:      "a8ce272cf78d1ac75457a452997e118d446fd70a97b3f3b472ba13986a7c1ae1"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
