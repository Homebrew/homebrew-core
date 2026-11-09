class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.38.1.tar.gz"
  sha256 "2b89308a7e5ceda12b5919a77639addf0fc6ffda6f649fb2bccfa9a73944fd1a"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "783230fa82fa7d6733f45f4f51f7c5bd53ff69f25ce76b244089b679eaf08ba5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ec3f3498b4d6f6584138bbda9be0d5abdad3473ba71d5010d73bd12c28080901"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dc509d7351ccc7aa37e754a1c588223ce6755ee4f6e2337fe8be3543f5fbb1ec"
    sha256 cellar: :any,                 arm64_linux:       "fd1427a1986f76473909b5427356539604ce20d5180d8d4636bcff4c0d835386"
    sha256 cellar: :any,                 x86_64_linux:      "bfb59047395f24ee7ed44f4a7953bbbbea2efbadf7523b9cd36c8db1c789701d"
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
