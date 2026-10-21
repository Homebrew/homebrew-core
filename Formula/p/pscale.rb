class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.347.0.tar.gz"
  sha256 "1032f82ab8ed9173a7cbaaa283380198f5e7360862a756d588fd6f03d9822390"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3942cf4cff64d81ea34c85f73859856acc43b66cb60fd72e52e6156354a76b0f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c05b049ab9d2c4ca494c096a41fb9eba215aa8417a7009560a282820f4c70975"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f2b791a92f6fdbc4037703871949ebe780e160451bb9558cf859fa3ca9dd009d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "15da1310e50088724c685ffe8f8b71121dd08780b714a0beb2f752d0265976b7"
    sha256 cellar: :any,                 x86_64_linux:      "e0664869deec9af414b999125f11db0a0c13e19f27d75f3d7fa352aab8570427"
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
