class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.37.0.tar.gz"
  sha256 "31bfdb3e87dc706dcc87a7f6a6343819f288af8c5ff0152c5793551e3cad1847"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4e5f3e43334664bd29b284230008c6042e448e1401222cc9e81ba895d5ca18ec"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9f07aaacc670e1c1257364b260c0d51c0037438d7cd63ab2cf161a66f5b27c61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c7d6eccb28ff6c1e19989989d9a24d32c36af142d932ec0ad1b1972431992edb"
    sha256 cellar: :any,                 arm64_linux:       "c5920d16efc40a2d6187430556de77899c74685795c4b8ce675080f5c82128e0"
    sha256 cellar: :any,                 x86_64_linux:      "a31f175631df9a1010bf61e34827ab2a43823856f51602176b127af671d26c74"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    tags = %w[
      sqlite_omit_load_extension sqlite_json sqlite_fts5
    ]
    system "go", "build", *std_go_args(tags:)
  end

  test do
    (testpath/".env").write("DATABASE_URL=sqlite3:test.sqlite3")
    system bin/"dbmate", "create"
    assert_path_exists testpath/"test.sqlite3", "failed to create test.sqlite3"
  end
end
