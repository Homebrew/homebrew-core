class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.32.0.tar.gz"
  sha256 "13225082e16e8c9f93f1421de2dc3c42ced31de0629b7d5fd668d4c8ade3a365"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "adf2acfcef50241ea7683db983852214ee8817ba2b8efe59dbf78bea942b01a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ece68c578841694549f907f2813eeb5d7ce96813eec46a98856d4a78fccaf034"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4b15d88282567759387f73c3373158e7f66a86be2d03db0f43fd370ac91482b"
    sha256 cellar: :any_skip_relocation, sonoma:        "160355089c59affc892457d3431231f57e9db47a6e7f14257e3b4acd2d12d67f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc7dbc56c42bf92a20f77dae6046a26c8a9ad61a5a0acffca3e2be45931701e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7e2b5fb33f9fea4796a3e9f416cef699b1036013296e0b1cf4c89202c422765"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    tags = %w[
      sqlite_omit_load_extension sqlite_json sqlite_fts5
    ]
    system "go", "build", *std_go_args(ldflags: "-s -w", tags:)
  end

  test do
    (testpath/".env").write("DATABASE_URL=sqlite3:test.sqlite3")
    system bin/"dbmate", "create"
    assert_path_exists testpath/"test.sqlite3", "failed to create test.sqlite3"
  end
end
