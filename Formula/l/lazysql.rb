class Lazysql < Formula
  desc "Cross-platform TUI database management tool"
  homepage "https://github.com/jorgerojas26/lazysql"
  url "https://github.com/jorgerojas26/lazysql/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "735b5a987c8a84a699d34d0cba1a3bcce6d65a46cf608d96758df6257ca353f7"
  license "MIT"
  head "https://github.com/jorgerojas26/lazysql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c8c44a18cf6e0efba9a0b5bef56cd0c309f6c0e8a7327c045510f55e8829badc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c8c44a18cf6e0efba9a0b5bef56cd0c309f6c0e8a7327c045510f55e8829badc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c8c44a18cf6e0efba9a0b5bef56cd0c309f6c0e8a7327c045510f55e8829badc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "844d13184d1e076d5871edd9dca3e6cd02f01c0cd5f79fe8f029dccbe6b5bdda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0ff654daaaeab959a36b75086566f6a970d9342f526d235762e478a21b40c7a7"
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
