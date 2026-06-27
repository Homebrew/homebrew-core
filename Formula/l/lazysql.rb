class Lazysql < Formula
  desc "Cross-platform TUI database management tool"
  homepage "https://github.com/jorgerojas26/lazysql"
  url "https://github.com/jorgerojas26/lazysql/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "f2ee82ca2bb4063eae8cb12c63cedaba39b1665dbe65492695105f4262c1c865"
  license "MIT"
  head "https://github.com/jorgerojas26/lazysql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80cd4f58c70c6afafe80c54b23bdf887dc7b10f2eaf64f3cab3b4823079fbcab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80cd4f58c70c6afafe80c54b23bdf887dc7b10f2eaf64f3cab3b4823079fbcab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80cd4f58c70c6afafe80c54b23bdf887dc7b10f2eaf64f3cab3b4823079fbcab"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5273969f300f652d94d803a7029d8c339327abf7edfaf08a8bde169f3840766"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fc3193d09ebf549922e77c5683aed50ae69f56dcbf9b55f95ec5dcf2aeabb36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1299771cadff601b795ce006215912ad14564106397bf31064475174ded93bc3"
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
