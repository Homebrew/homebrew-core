class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/refs/tags/v3.19.2.tar.gz"
  sha256 "a3ddcb2f128470cbd6b1dc1bfea119c69ffceb9deaee40a5a5229db94938a68f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a51d29570ee711bc02c7370635b50e7e48bfcee655975a78ca884a606139cbc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c5e4b1e99026c17fd72f097b15364b1b9c13c1744aa4ee1ae0430d4f981c01a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba6a080eecd8892c567df65b13d901b33de80f3f52022ce5e5b182e1ae8c1ea1"
    sha256 cellar: :any_skip_relocation, sonoma:         "783b0ccf320133f243b0ac51edf61bcd7dbd30ffb1ab089de899d28508c24792"
    sha256 cellar: :any_skip_relocation, ventura:        "8906a36702b4f543cb95182242dd8770f0ac302c8ebb1688ed5ba5f846a4a3e4"
    sha256 cellar: :any_skip_relocation, monterey:       "cfcc1ed52857b30dd241c658ac3b6af890fce9170f8b5e29e31a472b02d54457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2571438c24643296bc3d20afd8d5135ec6f1a6a414f00c510e30bba6295b249"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-s -w -X main.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1", 1)
    assert_match "goose run: failed to collect migrations", output

    assert_match version.to_s, shell_output("#{bin}/goose --version")
  end
end
