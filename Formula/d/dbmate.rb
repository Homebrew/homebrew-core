class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.21.0.tar.gz"
  sha256 "bf11b55f4bb1bc11cc9a26f08a336f7ca111807586a14a4582a5883d03fc9639"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77bac1d73c73b7d42c43f23425b1ccbff795c95b66262e6140cd6fce61b46e24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "863095b4569931cb55aa658edd6d99748b50e8d500c085d747c4792d940b530c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88c5c60f3db5a08dcd3c2ecfabb371bfcbdc9b676135112c13a12df9d45a5be3"
    sha256 cellar: :any_skip_relocation, sonoma:        "62f0d7c47ea702365d440165f248fb7b4a021c1296edeaf3b145928c0f436c6d"
    sha256 cellar: :any_skip_relocation, ventura:       "b4d43d2d32f231ca84f5c93f7b2c78abc8bafc8581307e6adb968cb6076eb019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "563ac4dec2c12df391929196e78b6d02d40c4dbc474e543893791997886b1daf"
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
