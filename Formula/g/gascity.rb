class Gascity < Formula
  desc "Orchestration-builder SDK for multi-agent coding workflows"
  homepage "https://github.com/gastownhall/gascity"
  url "https://github.com/gastownhall/gascity/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "e35d375d404b434d46961cd2fe0f16618808381f8f1a2ae17b84890151da2916"
  license "MIT"
  head "https://github.com/gastownhall/gascity.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6ff6436b19bbde6a3210f967ea8fc246563158931ac6a5d31545a5c0924a41e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6ff6436b19bbde6a3210f967ea8fc246563158931ac6a5d31545a5c0924a41e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6ff6436b19bbde6a3210f967ea8fc246563158931ac6a5d31545a5c0924a41e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2c664f4e2fdec3c2143dfb34c6e1ef9a5778d71e170d8b111117589eb68e783"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e82e74e4c90aa118491f6f8b5a4beb9dd404faa7d17ff5e27200d2b17d6d10da"
    sha256 cellar: :any,                 x86_64_linux:  "6fb413ff407ba10ed1c653ed05a6b356357f25520b3f472fb017af1745543117"
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
