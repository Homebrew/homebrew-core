class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/v1.13.0.tar.gz"
  sha256 "acfe2d57fc81bfe7a02f60ba995f10fffbf5e93df62d6f263862eaf2b79c5413"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "375f0b71158b5040bd3b82426f82adc6826f5d53f0eb3af44637a8636134f48b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bfb652120253c0b4499a4fd2faa7bc902b79d265ff091d39ac7119c5a1c3d20"
    sha256 cellar: :any_skip_relocation, monterey:       "cb96aeda42c4c853c320901e40e5e97f6635ab17b61ca9b2621fbb171fed03b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "272c5f9bfa29944c963fa927d5f0977b30b178ea1bb2900427971af01d9cd257"
    sha256 cellar: :any_skip_relocation, catalina:       "94ebfb34347eb7e9ee62d8c36491f0bcf2eb2d97956ce8f81997b63293612abe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fae83bc9e6b821a8f2f1bb220c0014098db5f4a40dbb492313492b47fab59e8"
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
