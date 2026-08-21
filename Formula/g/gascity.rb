class Gascity < Formula
  desc "Orchestration-builder SDK for multi-agent coding workflows"
  homepage "https://github.com/gastownhall/gascity"
  url "https://github.com/gastownhall/gascity/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "2444a9ef08501b41eb20e5f7ad7dc84776d48f29b192e7a9fcd87409bcac9852"
  license "MIT"
  head "https://github.com/gastownhall/gascity.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "5cae02492a44f9445375783cf4b464dfe9be4b879dfafc9ddaf2e4081d17f58e"
    sha256                               arm64_sequoia: "2c9502118c6fc2f02a1d99313e498a2fd9f4b1be2becf4e314e2c669b197db7d"
    sha256                               arm64_sonoma:  "e4ad1852ae48555613a3adfd9c244546c165713fa5dc92bef00a6daf81c1bf7c"
    sha256 cellar: :any,                 sonoma:        "3db59f1eda3fc6a4afdad0d57dfad9e4fe1350a0af12546733e8af985ea25d4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93022130a0451a6b15898e0d567d2cf109926b579fa31bf0095ab68fe5d26289"
    sha256 cellar: :any,                 x86_64_linux:  "c9746af0a20800cba8632d3438c2f4a1a3f1b37c5cee54ed361f260543e3ee25"
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
