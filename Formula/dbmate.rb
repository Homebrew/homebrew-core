class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/v1.5.0.tar.gz"
  sha256 "ec9a19c74ce100094f729dec1877d34097856360c88a4371959a4a5bbb4d6429"
  head "https://github.com/amacneil/dbmate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "946932c1571f2ed959a588035991b70533e5d9141b5489baf78d52bcf7412541" => :mojave
    sha256 "b21f89fb8c5ec25db5a8c7d12fae7e1405d0268b6cbe2d4f823a2440a6885391" => :high_sierra
    sha256 "84be32d3501f2d87d77a0c843c841a1583c0a142bc287e85fb63ee900b29284c" => :sierra
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
