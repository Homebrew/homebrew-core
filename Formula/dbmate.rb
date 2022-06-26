class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/v1.15.0.tar.gz"
  sha256 "1460d1591c0c7340a90e6aee32aa123ec24d88f8e5486482d2bab318497a42bf"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e35b6b9b74664b179814b495254c15a6aa191b759cc05a58482a90b4ed615901"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf26693522e35af2e56358aee38da6a15492fda9b633e4cda19d966f9f3095fc"
    sha256 cellar: :any_skip_relocation, monterey:       "dd0cc58540888f752f66a08968041d89b1dab646cca0b25c68b6874866e85253"
    sha256 cellar: :any_skip_relocation, big_sur:        "b749903412be3fd3aa38e88812db7498ece098060c854ae13f8c656f32e999bf"
    sha256 cellar: :any_skip_relocation, catalina:       "da120c6051d51e51ff8e0f3091011a411f5b3fe030759fe412475a4467f84269"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d02f63e9bdd4dbe6a73ee82c4b385848f367c295509933044a167b07eafed9aa"
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
