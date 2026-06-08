class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/refs/tags/v3.27.1.tar.gz"
  sha256 "55c1da80ae3fbbb4b893dc80d569cd98d7089ccd8e54639f42a87032105556ec"
  license "MIT"
  head "https://github.com/pressly/goose.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57427c333956a1be6355eb9c3fe5d60be85ae9e9d495a616191a283deffbcf32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98400f3afe38672c137fb26a42f46cd585a996dff76636efc5b1a40726d4e818"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5518cd87c225d3d83c03e741e43d31d60aa9907e6907e0670842451b879210e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e682888273337ae7c308c380f9e3e42ef285fceb0a2a6c2b7bdfcdcf2787d920"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3faafbb2df138d0eebd11724bcbb42ebd270c71d9ad03405b614713a1c177590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b65e646c1ce234632b67690760c6d419a1de33eeb3276fc701bdfa6b7862cd3"
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
