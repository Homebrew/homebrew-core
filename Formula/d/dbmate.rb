class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.35.0.tar.gz"
  sha256 "a5090797f7da35159e4454f0c532b055dfdb9a399a332bb3cfed9416142b7ec4"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02b3ac041544eef2749801f988cf679146d49c1e5a0e7a76a433fe354946b816"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b8faf1bb9d50689dc6c27a38783df848cf883d7dab0bc1a8c5ced3301a363f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e296954cc98cb70b01949863b0cb1bda088c4fec61f3a3684ed46f32b2644098"
    sha256 cellar: :any_skip_relocation, sonoma:        "041e22e23065709a0d4341c649372a3808b9cd7030a65959244c9fafdd64d32b"
    sha256 cellar: :any,                 arm64_linux:   "7255e720f235c3623107178ffcd358d2a57a72c353d08590a319f002c1c54c84"
    sha256 cellar: :any,                 x86_64_linux:  "9e4d1cf72f25ed97568ada7ca044a5bea4d4549b031bd82d34e8566259f4a5aa"
  end

  depends_on "go" => :build

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
