class Gascity < Formula
  desc "Orchestration-builder SDK for multi-agent coding workflows"
  homepage "https://github.com/gastownhall/gascity"
  url "https://github.com/gastownhall/gascity/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "5ae0e1eb4cd3df2a8e745c61df9f60a092cb037ffdb8635d25330e9a36ec619b"
  license "MIT"
  head "https://github.com/gastownhall/gascity.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "bd3c973a1bd6d367310b18f4e246057a405d8eed2665c813888e1cdd89b4b66b"
    sha256                               arm64_sequoia: "7bd9ce0d444ff404a048ee470891b74831d42180280c537397aaa66320b53030"
    sha256                               arm64_sonoma:  "26dc35b92549c9e9e8af9e67e6c6a28aec0ff9fa8e1090c01fa6a0ac4bee8440"
    sha256 cellar: :any,                 sonoma:        "f2cbec725c1a9e3b5c9131e273d301f76b246132f16854811b93e5be2f8ee111"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b2c2b28c46161be78427cf0a871bed1f845d309a0f3d48383a3bb79b42d0cd3"
    sha256 cellar: :any,                 x86_64_linux:  "7d5b7ec63fe4e476a945b1d2890f4d53bb8fd1f52f7692fb986a2421c4e0d7f2"
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
