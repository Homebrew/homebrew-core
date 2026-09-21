class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.36.0.tar.gz"
  sha256 "a72ecd5a04ab627a6e2e0a3d0caace438e1f0a584d6ea5929640dda60fb8c8d9"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1532b7d23fc81dce68d26fe307ff124889905f96212e7452e5832af9b7c1d617"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8ecb698cbb6210fa5ac5c042633abd65dc255caac82c1110f2be8388c013e9b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7cb32fa11d63ba4361450d473e2d667d28bd5ffdd31939bb7c680bb7ef630c3b"
    sha256 cellar: :any,                 arm64_linux:       "5f2b246c7977c21c7f484fa6440183c5c46664c352c9864a7ab370028aa403f7"
    sha256 cellar: :any,                 x86_64_linux:      "3cae43243ddbd624e3b92ecce4a900bb35f43cc81cb510a90ae95dd8fa2b4fc1"
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
