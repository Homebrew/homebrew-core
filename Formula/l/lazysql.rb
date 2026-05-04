class Lazysql < Formula
  desc "Cross-platform TUI database management tool"
  homepage "https://github.com/jorgerojas26/lazysql"
  url "https://github.com/jorgerojas26/lazysql/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "92a36347c064e2440f4f4bf38d3555ed282bb5ca7f0ebe3884d507cbcabaca9b"
  license "MIT"
  head "https://github.com/jorgerojas26/lazysql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a93e7c36bfb43ecd21894a000abf0fae7bb4f1fb09bd742fa71b1f224dd66a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a93e7c36bfb43ecd21894a000abf0fae7bb4f1fb09bd742fa71b1f224dd66a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a93e7c36bfb43ecd21894a000abf0fae7bb4f1fb09bd742fa71b1f224dd66a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "91bcd278994b31a727acf05744f9dffd878a703503f76a8a693f01a0f15d1d8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "723d435ed81069bbacf325457438c4e90c299d7553b3b2c15ac41f186e063602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d74b913a732fc028ba714d142425455d04c05e1499f09356337a1a4b5d5f3e24"
  end

  depends_on "go" => :build
  uses_from_macos "sqlite" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    path = testpath/"school.sql"
    path.write <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
      select name from students order by age asc;
    SQL

    names = shell_output("sqlite3 test.db < #{path}").strip.split("\n")
    assert_equal %w[Sue Tim Bob], names

    assert_match "terminal not cursor addressable", shell_output("#{bin}/lazysql test.db 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/lazysql -version 2>&1")
  end
end
