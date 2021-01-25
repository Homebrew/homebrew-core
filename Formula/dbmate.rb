class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/v1.11.0.tar.gz"
  sha256 "97c017061a6ae1d3f2c614306639990fa0dab656e329a353467f9515ca999bb9"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ff8a77e409a899dd70559f72a8e8501df068ef6c6f1095f3ac1f28b0122c241" => :big_sur
    sha256 "466238443d72e6d0f7bcf0c92a977ee34ca7c1003d0f355aae895725fe12be3a" => :arm64_big_sur
    sha256 "5223d60533452d4ddb6d9d140418f74b263fec8ea000cda0f9c1757b4c2dddef" => :catalina
    sha256 "547cad2cb3074d94999ddc6e3fc0a4b3000a0e91287bfb5192ce74fe89ca62e4" => :mojave
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
