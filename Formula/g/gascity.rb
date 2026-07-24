class Gascity < Formula
  desc "Orchestration-builder SDK for multi-agent coding workflows"
  homepage "https://github.com/gastownhall/gascity"
  url "https://github.com/gastownhall/gascity/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "e3c0e9e96e1eca637a894847e0525bcb5c46edcd68ce96c026d4b453e4604756"
  license "MIT"
  head "https://github.com/gastownhall/gascity.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "adbcef7c8c2b5dfaa85d8acbeb82f0558ffb70f56e44185f710def2766b4aebc"
    sha256                               arm64_sequoia: "0dfa0b08651bc0867bb093d0afb7c8a186e57008a6da05b5b20093a8a61121fd"
    sha256                               arm64_sonoma:  "af99499c07ce1b811992dbbe829814f290a697199692cfaa1991ebbe084fbc16"
    sha256 cellar: :any,                 sonoma:        "30e310b919c35757e846f22e31110db6758da72f8feaeb7b3d5e6311abfb152c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc477ba00b56848d4c3fc0f8530023f0cfdd63b2ec21327cf3b84e8422597b94"
    sha256 cellar: :any,                 x86_64_linux:  "c0923f94be63ec2530eef12315b7167d616b2f87ad4f2fc45725dd05e8dac5b2"
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
