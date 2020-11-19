class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/v1.11.0.tar.gz"
  sha256 "97c017061a6ae1d3f2c614306639990fa0dab656e329a353467f9515ca999bb9"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c3359021c62b14a50a3478e5e64a28ea310de8e5cf62c449120b89d4e205baa" => :big_sur
    sha256 "40c2f2d04a9d033478fdff1a272fa0d125a1dbdd746154afe97c5c36612a36af" => :catalina
    sha256 "11a6e1840fba35c278f3312b36ce1045c79e15cd51148f1cfe2e5172075585e6" => :mojave
    sha256 "861621c58be22ec75cf0c4c0539facaa526b69aee1ba14d697c7b9a52bcfac6c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s", "-o", bin/"dbmate", "."
  end

  test do
    (testpath/".env").write("DATABASE_URL=sqlite3:test.sqlite3")
    system bin/"dbmate", "create"
    assert_predicate testpath/"test.sqlite3", :exist?, "failed to create test.sqlite3"
  end
end
