class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/refs/tags/v3.28.0.tar.gz"
  sha256 "71644c9d60710096ecc721edba4edf44e1f53cd0417564321c4b848e26c75bfa"
  license "MIT"
  head "https://github.com/pressly/goose.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c1f7b5d4593fd50d34f05c242c5fa64128de354f3e5a07fd0f5c448fdcdc790e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "482b8e7d37cf41e60761a398d576b17bae658a6dd981c33009775c5d18550454"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b017cc08ed52d83b8bb586d5064d5a778170425e7b793fd7c17dba4f22d9ed51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "42b5d98de4039b5a747efb56f3e11544b2220793f5ce022962bb1699d01fe126"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7a7c7c27be0c3edb9e0992e8d88ceeb227440873e4cdb11a873880f70773787e"
    sha256 cellar: :any,                 x86_64_linux:      "5460126d7689fb58bde8f81e9e1b8efaee4561bc6fb11f3806fa35116ffbbdc7"
  end

  depends_on "go" => :build

  conflicts_with "block-goose-cli", because: "both install `goose` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X main.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1", 1)
    assert_match "goose run: failed to collect migrations", output

    assert_match version.to_s, shell_output("#{bin}/goose --version")
  end
end
