class Gascity < Formula
  desc "Orchestration-builder SDK for multi-agent coding workflows"
  homepage "https://github.com/gastownhall/gascity"
  url "https://github.com/gastownhall/gascity/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "b0266580ed3d4ac4081a68004bcb03fd702b853b9ca4554d85fe2aae30bab8cc"
  license "MIT"
  head "https://github.com/gastownhall/gascity.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "92305b4ced2948b86c086bf2527a35429d4dbcc973de361695e4e07ba2e38f1a"
    sha256                               arm64_sequoia: "9da3f82e74cd3ab44fa349efee58b105a41c6a105c8951c3766dc8b7c7f9e832"
    sha256                               arm64_sonoma:  "731dbd90c5f019a0cf10ec92e001fa9a8ddee59c25355d855c46dca90cdea969"
    sha256 cellar: :any,                 sonoma:        "ff5bc94ebbf8b34dd1d61713760df4dc48e12facc069fe320c60b46a22253567"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b96ded50b79dbf94b962e03bdfc5c2a74f307ab9212b34d8a2ee62f6c3603e33"
    sha256 cellar: :any,                 x86_64_linux:  "a48754cc26be5104fe905d2bf8c3682030f713abe5b0603db26475cd240f6daf"
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
