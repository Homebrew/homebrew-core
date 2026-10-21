class Gascity < Formula
  desc "Orchestration-builder SDK for multi-agent coding workflows"
  homepage "https://github.com/gastownhall/gascity"
  url "https://github.com/gastownhall/gascity/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "b36a0e00e7bc6c0c4e759a0639b2d88ecd80c51f1c682fceb8d03ba56fbc9a2d"
  license "MIT"
  head "https://github.com/gastownhall/gascity.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_golden_gate: "7d41f9aca007b375f741d3ea83ac27752a8423129b577eea7c0578cbb1ca6915"
    sha256                               arm64_tahoe:       "aab58140f12f9bd093b149a89b2dfed47567197de7590eb7ca33410690319446"
    sha256                               arm64_sequoia:     "4cf709f8fa783a0bd664ca705c9e19393b15a1c0cf8b0bb1710e875f24be559a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a4bb8299446be26ddeb7f00821c5a5446112f303ffe93c2a434422a593c60284"
    sha256 cellar: :any,                 x86_64_linux:      "05d35bcc664ac55cdbfcdb3b6b46a2c4ac2a90b85dc694bf6e1842532f581499"
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

  conflicts_with "graphviz", because: "both install a `gc` binary"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}", output: bin/"gc"), "./cmd/gc"
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
