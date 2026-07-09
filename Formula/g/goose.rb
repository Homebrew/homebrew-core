class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/refs/tags/v3.27.2.tar.gz"
  sha256 "7a99030eea486afd72a846e3d02c7ea959ddc0913f391a15dc572c1b683d77fe"
  license "MIT"
  head "https://github.com/pressly/goose.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9507001e3ad22b04bc6589488d28790c117b70ed6557fdbc3fcd0fce0edc00c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "820445d49003b9816b8a1bb70addf3d57d3c35e5477dad2c3314a0c6530c9834"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3edaff13c1ef7ec977d5ba69fa2e79a26b892ab7bee54b5e8c3cd41ad629f19"
    sha256 cellar: :any_skip_relocation, sonoma:        "165349c57d7071d0438df968084bd73ac889bf9046ae38659a2a735dba7b99a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b64eedfdecfbe981ae90b22b1defb04a276a06c769c121206c2df86596d08720"
    sha256 cellar: :any,                 x86_64_linux:  "7cc1d5a9b0b458f6ba374bb4e4df7209958d0d192e98b32ba0b54c310bd10622"
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
