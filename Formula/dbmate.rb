class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/v2.4.0.tar.gz"
  sha256 "97def53e8b7bd7b6190c480d05e759a6123c29c0baf6923b2c44ec66e870fd48"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b602f8e90d114cda35cd2cf049fe3317009673a440be878e3d9a450baae55e7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72b7814abaf0004c2d42a623c9ba8f3d2097e887daf20bc67b40bc2735387e73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe15790f7cc67e7735932cd1bdd87efa38c32c23a56b6117c40f6256e1d32ac5"
    sha256 cellar: :any_skip_relocation, ventura:        "17d4d507248240941e2241684e72900ab10486ef19ce3007f8995bfd0fe8d6e3"
    sha256 cellar: :any_skip_relocation, monterey:       "9a763c8a9e7f21b5c631bf101afceac12fca7e63e9ced9129c3a02b74aa612c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "6318efb3f5417c4d062b3f13ccae6c0f8a936f4b0bee468488bf0c24b7b278e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82f11dc7306f2ddc65ff1966d691417c867b75a186d098c17b264bd5a86c33a6"
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
