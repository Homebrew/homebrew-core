class Lazysql < Formula
  desc "Cross-platform TUI database management tool"
  homepage "https://github.com/jorgerojas26/lazysql"
  url "https://github.com/jorgerojas26/lazysql/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "90d6943d0208964aa6143da9d0768fa0dfc2bfd7a4ca2302ba7b36ec92808334"
  license "MIT"
  head "https://github.com/jorgerojas26/lazysql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "887ed35fb2af3135dad54106147a99f65c286312fa8f97d81f79a3da24addd53"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "887ed35fb2af3135dad54106147a99f65c286312fa8f97d81f79a3da24addd53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "887ed35fb2af3135dad54106147a99f65c286312fa8f97d81f79a3da24addd53"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c0f58f583d8572bbc9b5ee2cd0bd67ab0cb4432a139ccc445cf69ec69b58f3d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f4a26ad3be58ad4cd98b2bd08166d1b4a8c6547f19ce0c5ed0bf3507160fcad5"
  end

  depends_on "go" => :build
  uses_from_macos "sqlite" => :test

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    school = <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
      select name from students order by age asc;
    SQL

    names = pipe_output("sqlite3 test.db", school, 0).strip.split("\n")
    assert_equal %w[Sue Tim Bob], names

    assert_match "terminal not cursor addressable", shell_output("#{bin}/lazysql test.db 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/lazysql -version 2>&1")
  end
end
