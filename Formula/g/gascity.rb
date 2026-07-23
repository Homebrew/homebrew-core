class Gascity < Formula
  desc "Orchestration-builder SDK for multi-agent coding workflows"
  homepage "https://github.com/gastownhall/gascity"
  url "https://github.com/gastownhall/gascity/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "e4674cbb00a836b8cf9cb9aac06a7d8998805d810658be1429bbecace8029b86"
  license "MIT"
  head "https://github.com/gastownhall/gascity.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "4902acaeed8e4117f032897c3c093a08ac6046b6a5ae42508e4cf21c60170a1b"
    sha256                               arm64_sequoia: "8f6bffb15855ba3dc3f08bb2e50513c149ee73fb306fd083b7e34e67ab9720fa"
    sha256                               arm64_sonoma:  "6984fc5e00c6597ff79d6243464835218b843cf06207419d93f0f9d212cbdb94"
    sha256 cellar: :any,                 sonoma:        "1cfb53c541cba46005dc0366af3edbfac78aaa7cbe61fefa4b0fe9f5751f7fa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "965f64b94945179dc8be2ab05962d2826467f29bdf8ac164c033156a9a541218"
    sha256 cellar: :any,                 x86_64_linux:  "0135a0f6a9e5d3ef9ab791382131b1f3562f12019db1a23f0dc1dd6d18a07f31"
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
