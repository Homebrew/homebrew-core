class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/refs/tags/v3.25.0.tar.gz"
  sha256 "46002cec9b0ee3f3f87739da329c40007009e1fbf1f71e02028eb5e3614a67d4"
  license "MIT"
  head "https://github.com/pressly/goose.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e19bab9fc61373de832891de6f7c2a5c425d66ce846f25b790e1064775472708"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22ec9bc1bdda1eb1b0bc7a6388a62cf1f5e46b598befe003ccade58c5f971b10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a122f9ec4b99aaa817c86a7c1b8fab47b91966d4ddf7c0a437077bba07e4185"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db546815613867cbca01d7e5454bc5ebc1e6edc5ee78a65b7381eb0e4fe145c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "11ba39b923ea6e65f7b218561120435de1d6037f166e9a796d5d0e2e2bef5796"
    sha256 cellar: :any_skip_relocation, ventura:       "4414da7f544c6b960f9333718f2354445c2275fd2c49e72cfdc7ef30cd0a8026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d3dc7c104c9624e815e9d9c2c17ac740e8c6829a473720740da07b95e148fbb"
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
