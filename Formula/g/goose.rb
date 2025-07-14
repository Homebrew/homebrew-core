class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/refs/tags/v3.24.3.tar.gz"
  sha256 "f0d0e654b7f1e242beb27b49db7b3dbb0788e330c9c4a9e88701c7d3570eaa00"
  license "MIT"
  head "https://github.com/pressly/goose.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "105da62c75210a95b2428f1f7f8e71fd6a6bc4e307c1bf0da10cd907c20060b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f58f77cb92cb2852fcd46c3171ea304b13283b6c0ea093a6df00752d3983b96d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "06af6db1a2e82d1a187184ffea1380f41357fe2b181f8c4e1f446d2df544239b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b957bf72a2377ae0e2390a9d3ce9249f29c58b1d25f4f24908dde248b70ddb5"
    sha256 cellar: :any_skip_relocation, ventura:       "c58e55b3554f5f1c4bbc37120b00f2fdd63cc02d98797f7eb98d9b3fd354b3a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa0e8e6543271a5b1b39292775c21435e04daa32f6287f0f47424b511e89a407"
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
