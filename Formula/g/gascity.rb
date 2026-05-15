class Gascity < Formula
  desc "Orchestration-builder SDK for multi-agent coding workflows"
  homepage "https://github.com/gastownhall/gascity"
  url "https://github.com/gastownhall/gascity/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "ae37e7dcc31e6ca3db435940c305bff36510dd2e32dbf472260c3eedaab0826c"
  license "MIT"
  head "https://github.com/gastownhall/gascity.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3eb9ffb5796ecca8e33284483c7ec620920ffd2256794d9907506709275e8630"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3eb9ffb5796ecca8e33284483c7ec620920ffd2256794d9907506709275e8630"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3eb9ffb5796ecca8e33284483c7ec620920ffd2256794d9907506709275e8630"
    sha256 cellar: :any_skip_relocation, sonoma:        "da9f6888208542374ab91a444b7d101aaa3161fd4c1d54b0e6f272f85a329b47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39cb848316971d3eba6f201503bd8d3f05e7f394c65858731c10d105eaad3f09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2447644e66d75f5a34c2453706fd7274aa62a45b126423ebcb07e4213aa7fed6"
  end

  depends_on "go" => :build
  depends_on "beads"
  depends_on "dolt"
  depends_on "jq"
  depends_on "tmux"

  on_macos do
    depends_on "flock"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"gc"), "./cmd/gc"
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
