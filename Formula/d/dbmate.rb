class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.31.0.tar.gz"
  sha256 "2114824a1ee3972887ea89b97c6932becf91d612f687fd6b79c4dfce7cd12353"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96cf426eb57dc8de1664e30203cf141f24d6cee8d4c923265af4af2834f29c0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c3f6ef1fe172a760e6911ccfc00f5a41ea79128622c3d39beb4956c78bae5d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0993be52ddda20c8ebc7a82ec7cab9bdcd48280ca34b53a7f19a82d7efda105"
    sha256 cellar: :any_skip_relocation, sonoma:        "09208d5bd0f5bfdd7a7feb1c618b36023490dd29a535f52d49aec22b7be6ec11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd656f990aee371ff45033db980d64d0b78321531dbabf3974a208045c0fb158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "829d639422d5e313b2d952ddcbc977056aec07342ae56b2ae552d03ee2d7cb98"
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
