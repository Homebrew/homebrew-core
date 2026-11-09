class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.38.0.tar.gz"
  sha256 "eedcb3bf5ab557dec2a4ce80f1af8e5468f81162d5dac4b29e410af195cd41eb"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6440a5308c7ac821997fa5228a2bed70618891dff0a1ee9015ae9e130f0013b9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6b2090fd26bf4d8d8ea47775c7738834c6098adf4911d31cbed7f6852c42cbb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "01fe80fc5f4ffbd8d84cadeb72f8051502a41ee17bd6d0735bfa1425c7fa6128"
    sha256 cellar: :any,                 arm64_linux:       "451267c1007d649b1aa63c4d2af865afab46a97c5c03f065b22dda62931f2511"
    sha256 cellar: :any,                 x86_64_linux:      "28e85c030664cee21ab03a02d483be48d6232dbefa3f422552963ce61f69276f"
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
