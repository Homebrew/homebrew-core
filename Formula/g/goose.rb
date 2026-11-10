class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/refs/tags/v3.30.0.tar.gz"
  sha256 "60bcb9527ca286903c8f8e4cd19ce15597a7bb080e795166ea356a3e3d04a920"
  license "MIT"
  head "https://github.com/pressly/goose.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4784341089bc1667487b25deafafa976100c46ce3450c10dc84db4b26ceda8d7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e0cf09938883f6c146507fd46086d4126335ac0686ccb6e3c9bf67d74319d4e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4081c6d4cae3eb27c8406d85b3b7493a4f996b624173c4535f3230f03c154f25"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "83c99e59fb5cd67bfcf81bac0daf9077c185a3a33da40a8ad18925590cdf123a"
    sha256 cellar: :any,                 x86_64_linux:      "9d22fa1c441ca2ef5b768edb468e7afccaaad580cc76b2018ffae7a6655beea2"
  end

  depends_on "go" => :build

  conflicts_with "block-goose-cli", because: "both install `goose` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X main.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1", 1)
    assert_match "goose run: failed to collect migrations", output

    assert_match version.to_s, shell_output("#{bin}/goose --version")
  end
end
