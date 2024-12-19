class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.24.1.tar.gz"
  sha256 "2129be19cee8c027b11d8a4a258ad79b661cb9e740f431bdd9f53e4c403cde1d"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fc502f4f0e77b182d7958b077f71ab7aeb0d93df0274971a9c43ae946c1abb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee1653e73b396151b03b5aaf0a50b2ad22f6fcbd096440c0a8ab915aefc3d425"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a28629b9fcbdcb785099cc79ad8955b3ed2539db7ca7d8beceb6b6010b86197"
    sha256 cellar: :any_skip_relocation, sonoma:        "18cf74b7535c71ff540dfdb3e646fcb722014f84810eae68945b951ad4ec6225"
    sha256 cellar: :any_skip_relocation, ventura:       "3337c24c041fdd075c3d35e343d7bdefac1fc1f223dc412e5571c0d12b9b4fc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d308fdd56342c1072a867ba1a6f2a974db1f9120f0a270c0fa8c337d6762f838"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "sqlite_omit_load_extension,sqlite_json"
  end

  test do
    (testpath/".env").write("DATABASE_URL=sqlite3:test.sqlite3")
    system bin/"dbmate", "create"
    assert_predicate testpath/"test.sqlite3", :exist?, "failed to create test.sqlite3"
  end
end
