class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/v1.9.0.tar.gz"
  sha256 "8c7bb27b12b456b962a1d7828de048f7f0d3efc6ac0a3494fcaebe7a3bd3ad00"
  head "https://github.com/amacneil/dbmate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f32b635f7957db182d429992c753093b64b8bf7c2c555327f78e37bad5c37eba" => :catalina
    sha256 "0c9bcf257cee488ffc75cba4b4c5ba11e31bfa8ae0c82f1da9716ba8dbc78a43" => :mojave
    sha256 "4d0ea4ccdad77c08f9747cb19ba23913e9e287bab1e0a80f0b320d27ec85df42" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s", "-o", bin/"dbmate", "."
  end

  test do
    (testpath/".env").write("DATABASE_URL=sqlite3:///test.sqlite3")
    system bin/"dbmate", "create"
    assert_predicate testpath/"test.sqlite3", :exist?, "failed to create test.sqlite3"
  end
end
