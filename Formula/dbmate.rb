class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/v1.9.0.tar.gz"
  sha256 "8c7bb27b12b456b962a1d7828de048f7f0d3efc6ac0a3494fcaebe7a3bd3ad00"
  head "https://github.com/amacneil/dbmate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "380ddb2a725ca5e1657afd10acd7b343dc1c5826a4a455f8efe24e7c9bf3d779" => :catalina
    sha256 "968002c69f18deead19c7f7e7ff9a387df34e7e30abb094c2176d6dc96f74e2a" => :mojave
    sha256 "b2956de9991ef878a24b0e14a64527e7642fec5330ae8b5ca1c5d509adb42506" => :high_sierra
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
