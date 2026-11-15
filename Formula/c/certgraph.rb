class Certgraph < Formula
  desc "Crawl the graph of certificate Alternate Names"
  homepage "https://lanrat.github.io/certgraph/"
  url "https://github.com/lanrat/certgraph/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "2f4cfc8bea214db05d958bc0faf468e97e646b0b2e6c9dba45f4ff122393cdc0"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/lanrat/certgraph.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c15573064d15a0d1608b1ee9bd7766c28acc7852a62f5c9575202fce1d6ed0f7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c15573064d15a0d1608b1ee9bd7766c28acc7852a62f5c9575202fce1d6ed0f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c15573064d15a0d1608b1ee9bd7766c28acc7852a62f5c9575202fce1d6ed0f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "54c3056d1ac9ef5d7abb9fb01e8fba94e15c7a7b254ec30aa1aee13c3c5825a7"
    sha256 cellar: :any,                 x86_64_linux:      "bd653f949c009c588a2401c639621b6ffafeac03297daeb5c06e243262044d88"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    output = shell_output("#{bin}/certgraph github.io")
    assert_match "githubusercontent.com", output
    assert_match "pages.github.com", output

    assert_match version.to_s, shell_output("#{bin}/certgraph --version")
  end
end
