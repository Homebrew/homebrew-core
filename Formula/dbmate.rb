class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/v1.15.0.tar.gz"
  sha256 "1460d1591c0c7340a90e6aee32aa123ec24d88f8e5486482d2bab318497a42bf"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70848522f0c4423142f568e2f86ab3e8b7a6abf364092db41c9ecc5f86990393"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d755d286c80f78f403e9861cf45f71a967a3583d1baaf81729808fd281f9a76f"
    sha256 cellar: :any_skip_relocation, monterey:       "02ee01ea88bc8b99ef575ba619db20e314b6bacf4bd1c190c4d1946277450b29"
    sha256 cellar: :any_skip_relocation, big_sur:        "5621dcb08777c80c64a11f202c852536fbeff6d7746d5f45544954aada58515b"
    sha256 cellar: :any_skip_relocation, catalina:       "c307185bf0c0f4e815b13275bb13db6f5396d71327c1516b979cf707f1946387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a324736891341d3c3f1109c3db11863df97d3685b3ac5c218fc3449a6b4bc034"
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
