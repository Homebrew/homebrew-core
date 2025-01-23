class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/refs/tags/v3.24.1.tar.gz"
  sha256 "d8a9d66ce09dae81911960ed82a0bed5099319becd603e895239e2abe17c81c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a75a58ae73da2ea0c759fa10012eb30c34d08856a836f44c2ab2428be16e7b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdfb01910e1d6db4a6c39b063d808f59a61e5ce86bc11b3731f9d58a9d9e4999"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67a130272ca3901a9c994cd123035ac75d0931695b75cd200cf9f15ed513e783"
    sha256 cellar: :any_skip_relocation, sonoma:        "e82330a7dabe60f6b7ff1d2e8e7402fca21a8b883c1cced53ef6e19df21e679c"
    sha256 cellar: :any_skip_relocation, ventura:       "a97ac680214f51769ca5701eb134d60eb6797798d9eeabff69c7500579209d6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37e1d28fd1538404c993c84bb466f7cc84c13ba3601daaf7139ea6a6bf792ef0"
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
