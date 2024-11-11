class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.23.0.tar.gz"
  sha256 "7f252e0a1f2e4ce8e88fed9e5a0c258167733e72dca1c6f1db41f635470ab3c0"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa47e133ac95c2462aa844cbccaac213c9046d19219060956bd469753b2be0f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3697000a255531e7d8d8e17c8f20b620484768811a20b3126f25e0d8ccec49ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "703730ccf386316822b408447935441132ff632a059f4cb6aa4f3cc759b62b71"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4f800dafd862e9c6285b3c6e6de81a9c89026bc4dbf1206695d3b537b4911e9"
    sha256 cellar: :any_skip_relocation, ventura:       "84a741d8b8f9658e465bbf1f5c3777445ee90f9e5eb5c8553f07d630ed673f96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a8f569a26a36564b7377ec1a463d9eba1fe3aaf166c0f17d23249891332f7d3"
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
