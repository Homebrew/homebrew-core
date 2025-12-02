class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/refs/tags/v3.26.0.tar.gz"
  sha256 "fb93daf1aa33a5ef0dd5a3b8ca18f79181b4947930df3fb26e2ae26c9bd2385a"
  license "MIT"
  head "https://github.com/pressly/goose.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30530a391aac72dec45db4eff2dfcefd6bb1a9095161fd15e1fa8cada6a10be7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2c6066f878c5e0aeafbdbccadf574e324ed3d888c27869b3cfb7fad4828ea52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "093568865fda9c25594bc98250c276a18da697ae11235f4d3977265a53293870"
    sha256 cellar: :any_skip_relocation, sonoma:        "74559ab416949e294e5de5648da820c96b651b50d9c866ef94f1cff6c4dd71eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac71ed3180cab9193c6bce59f909d030ea8b2deacefe96d1e8076256a362a364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c31a5b03d697c746a4d67aad2308335d50505d9a7900627d87abfd3e787b4adb"
  end

  depends_on "go" => :build

  conflicts_with "block-goose-cli", because: "both install `goose` binaries"

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
