class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/v2.6.0.tar.gz"
  sha256 "44d39e3b79b2c08ac09186db95d7f44bcaade04e49f3dd9d6ff05043b555a30a"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e29fe79e8a2656366f90832bb9b48cc43d9f76898289b23683c416aaf099264"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf98f62bb5a2d18f3b075eebe0b76313f6e41f46cfdb2fc105e386a36e653617"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8cbab80894be04e5ea50301b666db34d97ff3516a8d1bc16a2eaccf72473566"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4028a90a25875319ba554d441991232f31010a7bf0d4eb7b4b2c8b8bb9ef0130"
    sha256 cellar: :any_skip_relocation, sonoma:         "f63da9f0a0d7f2f5511cc84b640f9c0c3ce9f02d40c03bafca0062f3b06584a9"
    sha256 cellar: :any_skip_relocation, ventura:        "778e673d1529753eed6ce2e3ce952dc4b81e37004462f8a138dd5e4290156cad"
    sha256 cellar: :any_skip_relocation, monterey:       "925800f0f36e28a22451b61b3564fdf928ab9b53a3142b55ae0cd0585f068088"
    sha256 cellar: :any_skip_relocation, big_sur:        "1bbcfb4324f14ca75360929156082c48d6237d53caa0d80dd89473b738c03c68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35868100036ab8b7960ad506666a17b46a9a32daa5c3f6cb17835e3c2d6b5916"
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
