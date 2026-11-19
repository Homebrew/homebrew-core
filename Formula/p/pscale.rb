class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.355.0.tar.gz"
  sha256 "32f65d0062e2e082f524d0c8d8230aa524f02c7f643450994ef6a3efbabc603b"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b91368a19b7cb9f287f12be9256472d5f839d2141bf49a617a8c898a764b06a4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a3ab639b98f0b7b5bff8b621b94e3d98583b2e37a779b314831b0e98058b51f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b307c77dab74a08b9cd7057a8a152b6e927a31035922fc4992b80141881fff9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "57f1821cd82f48705e4ad7175455f12716917ac123dff018ab1d3ed21829c4b9"
    sha256 cellar: :any,                 x86_64_linux:      "da9287a2891e6ee6d8fedf6b40bee11358b273c820eedb5507a168269b0f6218"
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
