class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/refs/tags/v3.24.2.tar.gz"
  sha256 "1b0832f7648b04fdd69e28f4ade98b54acb4ebd8a403bde02375ef6919298261"
  license "MIT"
  head "https://github.com/pressly/goose.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72dd8b35daa4c4203c9af437e8545be1164d3ee21f3639fa01bf599b615686b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bda02dedc752e29ba8ea7926084d23175f3aa0d56e68b6dda6dbb71cb7068ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9f8c11194b34451e667c3c6a3cc0e1fb03c5702ffc5085750ed2dce99af6157"
    sha256 cellar: :any_skip_relocation, sonoma:        "49bff1e9ff77389bb2b00fe5bca0c4ef8e8501a396a934a31e92843b861ed5ee"
    sha256 cellar: :any_skip_relocation, ventura:       "73ac88e9b90f495e34d70bc48218eec9ac894f171be723f4b92c57c19f2325b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "296fa7569c6b79a9221d430d4d13aa8f2a497de759ceb2cef93e7c752d843a24"
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
