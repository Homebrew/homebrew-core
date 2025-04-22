class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.26.0.tar.gz"
  sha256 "2fb78ed466505f20a4b060b8e103c6010bf788a4445b19ec1f0e5589739fc659"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efa9f1a111686d3154a5442ce1ccbe471c43dfc0e7dc77ecb1d9113ed45e101e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31c090c49ea219094f92eb452eb96d5edf23bd5bcd2c9020bd903ad4495e3eb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b631e1a546cf010561082f329b9932bd639bd02c4bb23681d0b05ddd556954b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c1bc85bad4eca018413b9c120361579f7da6c639256d440abfd2fea2753ae87"
    sha256 cellar: :any_skip_relocation, ventura:       "acc841718c7adbcce328bc67490d6e2127ba5ccf63a0eb255e680a7645615c9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a416a27ae18c6fa8859306ebf8a1d1f247f3bf9a01ed1efd1cefc870a185d5e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bf2da4805353a29298ca659dfd3d42368c6f2543bcc396fcc12370b1033011d"
  end

  depends_on "go" => :build

  def install
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
