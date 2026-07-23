class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/refs/tags/v3.27.3.tar.gz"
  sha256 "89ffece26aae3f06700a4a0a1349d0e3abd81075e449dee79056622062ed8907"
  license "MIT"
  head "https://github.com/pressly/goose.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce2a476c7487de0b908c968ca44a7e81714e5bd9343603b3e0487b22db62dd9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5290e5c68f1bf8768ddd6681e1ca344897a394f556cd8ecb47f0d4294e738a22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07b26a62868f8897c529aa3449020bb0beb111c0ae170a301fb0a563da305c2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "268808241333fbf2d11446544b229fb94a0c3820668733fe2a80eaf208f88100"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ede4a8e24a7abd45cfba46b7bb6f1ea5ab1ecfbbde0008db2ea5540852fb5e9"
    sha256 cellar: :any,                 x86_64_linux:  "dc1cf3775aa712bc665d9a1d92b36ac49f4032bdcc9a86af612fb1e0950e8cef"
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
