class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/v1.7.0.tar.gz"
  sha256 "042ede72743afa8a044f56908105760472dcfdca67880c2622a3cd75ae11ee3d"
  head "https://github.com/amacneil/dbmate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "22fc53306f4eeb8fd2e42a0dc1bc6d24528dc0fd132b7f6e40c1fd7ea089b897" => :mojave
    sha256 "1beb924a7fa984e36b8c8ec6c68909875d373b68eaf8cb41c98a3c1cf8b91bbd" => :high_sierra
    sha256 "14fa5dda74ecf2583e634cce57a8ad7a630ea0d8b932b2c0fd2428f52c4b04ed" => :sierra
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
