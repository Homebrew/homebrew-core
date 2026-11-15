class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.352.0.tar.gz"
  sha256 "170e0ce220501a27b277f609a7efdf073232b5c8e0c131a6ab38ee233fc9f477"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "df1283659b0b980bfa5260547289e63c4ba3222107e1363a12f145e9fb03f4ce"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0dd2565438ebfd57ff9996f276154f0b1fc96b14ee5fc9a4cc2b9479be2518d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "67831975a84ca73f4c31183f7ebd540a2598b294540243be031044397735c9fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0dc7220be807fecfbf1fbaf15153573d0bd2ef5405bb38bdf60168a306b027e0"
    sha256 cellar: :any,                 x86_64_linux:      "9fee5a1b111f96eb9c8865b630d8c834c00e34eec55e26b93da9e8a7aaad38ea"
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
