class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/v1.12.0.tar.gz"
  sha256 "fcb70bfe36f7118336ed191cba78991fcbc3b47f47fc69bb058ae8a9b265e2f1"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "34669b5f5f37d77540206b0274e97a505c1e26072f5d60f456ddba5bdf17d885"
    sha256 cellar: :any_skip_relocation, big_sur:       "928e602baa978c891124ab0ab595563976a953a1672b6d6f207bd7bba087f046"
    sha256 cellar: :any_skip_relocation, catalina:      "bdf5803badd7a93502382027d83ff70488d9270eb89e5ef5f41b73c777c3326b"
    sha256 cellar: :any_skip_relocation, mojave:        "136e800b7486127c794d7c7b57a3c490f5a5e556ba051ef63729b612b60f7ddf"
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
