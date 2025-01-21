class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.24.2.tar.gz"
  sha256 "a134c289912216e380a94c0d8136c3df2f0296ffb3bceacff8d243a752cc2f8c"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7524d5b5adf73193ae81c091a7624fd2a20b2602855de120b0d32c0ea737d0ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0eecd85bb370655aab685e1f9f00f41112bff6999af485e6b04fec89ef8757c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c26c884f612550bf954403d13453810de022c959b6b44ece564f0cf9d6a7f0be"
    sha256 cellar: :any_skip_relocation, sonoma:        "7dd8d35f50fb812e5b4dff66553b01ed0ca5542ff25a8cbbb9c0c960d55bb233"
    sha256 cellar: :any_skip_relocation, ventura:       "a712472c7d8ed8d9def04d8c2a70ff4fd9d6d13e936ba0d338958f3456968f40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a9be764abef88ffb96c85b74d210c1096003ef9322649f5e518bad00ee3c9e0"
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
