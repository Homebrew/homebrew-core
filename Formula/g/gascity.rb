class Gascity < Formula
  desc "Orchestration-builder SDK for multi-agent coding workflows"
  homepage "https://github.com/gastownhall/gascity"
  url "https://github.com/gastownhall/gascity/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "ed81257ac3e7d1d3cf96036dfd7039350f5852bcd556f6842da6cb714e0022ab"
  license "MIT"
  revision 1
  head "https://github.com/gastownhall/gascity.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_golden_gate: "5db6dad98919814a4ecb77cad1acf1f84f25d32d7337e05af6a2f2380f9328e4"
    sha256                               arm64_tahoe:       "5f981fc987235130365f092e8c32d26d72d586cb042c3a7cced7e4a7a07433d1"
    sha256                               arm64_sequoia:     "ffd0a1b922a012d94ca0e814f5a09644871a6528f0ebb715a2dc0d798f422373"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7a2fde8edbd5dd9ec9852507c693dbc239466422b316baade8a473638f497ab7"
    sha256 cellar: :any,                 x86_64_linux:      "c53b0507d76a520607026e9b300e5752ce4d197b812642844894655b276071f1"
  end

  depends_on "go" => :build
  depends_on "beads"
  depends_on "dolt"
  depends_on "icu4c@79"
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
