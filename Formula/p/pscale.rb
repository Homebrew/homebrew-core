class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.351.0.tar.gz"
  sha256 "3f9b07650d655feb8fcfbb522e4ac47b9ad60b45c8b41f8ae33cec37d85b2016"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "072fe52e73ce1e0493155bdb75c65f031cb6d15467af22a5fb6cea4bac6a227c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "395d854146edf8e0d69609f4cbb2d112a4e180b8184f517dc7e435d74ebf3cf6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8e991d57943f902ebc5632836ed64243c42da59cf44315fe2cdc045d46e24127"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b1edda9926f7236d680fb756f5cacd859f19ed8875e535bdc904415197f40078"
    sha256 cellar: :any,                 x86_64_linux:      "7ffc9170ee052fa7e2adcf40ece83749ba8be8d39cdbe4fee26704b897ccc66b"
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
