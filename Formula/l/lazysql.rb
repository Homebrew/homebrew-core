class Lazysql < Formula
  desc "Cross-platform TUI database management tool"
  homepage "https://github.com/jorgerojas26/lazysql"
  url "https://github.com/jorgerojas26/lazysql/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "ec2cd213f36b4fee1e73f8da528a8e19344d1013d4a1af5005f66bc44f0b93fc"
  license "MIT"
  head "https://github.com/jorgerojas26/lazysql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95b6fc40e3925055714300088775f3183f9d09d7bee8864dc293c71c809fd59a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95b6fc40e3925055714300088775f3183f9d09d7bee8864dc293c71c809fd59a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95b6fc40e3925055714300088775f3183f9d09d7bee8864dc293c71c809fd59a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a9d80ae2a881cbf722da8667519bc09d0b47871ba42c62db2d35a1246749c56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1181c1224118e18d50f31cb01e27cd05b943209e3d408aeea45527fb8d56c877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67cc5f41f881aa63617deeb753fe9c996b54d6b361cf7e4e1fbe0b8d86122c79"
  end

  depends_on "go" => :build
  uses_from_macos "sqlite" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
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
