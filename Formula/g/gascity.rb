class Gascity < Formula
  desc "Orchestration-builder SDK for multi-agent coding workflows"
  homepage "https://github.com/gastownhall/gascity"
  url "https://github.com/gastownhall/gascity/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "98a4cc61249e7277357b1dd6adf526d64bdf312472f8c5568126c4d586d56d59"
  license "MIT"
  head "https://github.com/gastownhall/gascity.git", branch: "main"

  bottle do
    sha256                               arm64_golden_gate: "1e1b37f0210e5ba1f71e2da4a6c2ba5dc37abe6f44f2e767c933669ec546fc44"
    sha256                               arm64_tahoe:       "52f1734c5a0d697ab1d64f213c7e1b1a157a976d0f3bdbb791bbbbbd3ec9465e"
    sha256                               arm64_sequoia:     "fd4ac2df417c3d4af83ad99385d6e3f51792e61c39992728b928efa1d5b94451"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ae37be24a16bd92c3fdaaf92dd82083d905afcce2743fc67905ea70ec5f5bed0"
    sha256 cellar: :any,                 x86_64_linux:      "c5f8aa3dcb182bfb324fadd5bfe90b7a6b97f8b9fd8fa962c15241768b616904"
  end

  depends_on "go" => :build
  depends_on "beads"
  depends_on "dolt"
  depends_on "icu4c@78"
  depends_on "jq"
  depends_on "tmux"

  on_macos do
    depends_on "flock"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # TODO: Remove http2legacy tag when Gascity works without it in Go 1.27 (in release > 1.4.1?)
    # ref: https://github.com/gastownhall/gascity/pull/5030
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}", tags: "http2legacy", output: bin/"gc"), "./cmd/gc"
  end

  test do
    (testpath/"city-template.toml").write <<~TOML
      [workspace]
      name = "brew-test"

      [beads]
      provider = "file"
    TOML

    ENV["GC_HOME"] = testpath/".gc-home"
    city = testpath/"brew-city"

    output = shell_output("#{bin}/gc init --skip-provider-readiness --file city-template.toml #{city} 2>&1", 1)
    assert_match "Initialized city \"brew-city\"", output
    assert_path_exists city/"city.toml"
    assert_path_exists city/"pack.toml"
    assert_path_exists city/".gc/beads.json"
    assert_match "name = \"brew-city\"", (city/".gc/site.toml").read
    assert_match "provider = \"file\"", (city/"city.toml").read
  end
end
