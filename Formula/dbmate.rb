class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/v1.7.0.tar.gz"
  sha256 "042ede72743afa8a044f56908105760472dcfdca67880c2622a3cd75ae11ee3d"
  head "https://github.com/amacneil/dbmate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e8b233775e3f4916fc0a342e1dd30a5af8fe5d59ac59ab961d2957b9918e2af" => :mojave
    sha256 "79784ca8ce7c443219a3c66fb4089cdda76dec37a1f0b08235d6efa59326aa33" => :high_sierra
    sha256 "f23e60c78dbcd764ea0ddf42c6ad6c858edcc7046024001839c3aabbed16ece3" => :sierra
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
