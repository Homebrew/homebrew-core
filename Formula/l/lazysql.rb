class Lazysql < Formula
  desc "Cross-platform TUI database management tool"
  homepage "https://github.com/jorgerojas26/lazysql"
  url "https://github.com/jorgerojas26/lazysql/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "e8a06583d19f1053be13be800db5a3b6d273b992fcc335f539c40e39a6485e4c"
  license "MIT"
  head "https://github.com/jorgerojas26/lazysql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b26f4a380fc5bd534c6366a8cf490890d8b4eb7e3e2baa164e896d1f4c03ca3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b26f4a380fc5bd534c6366a8cf490890d8b4eb7e3e2baa164e896d1f4c03ca3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b26f4a380fc5bd534c6366a8cf490890d8b4eb7e3e2baa164e896d1f4c03ca3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0539da42429bc08d8c2c90101c166af5b85a11786785eb855b082aa7752ca9eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b56c8926afdc815ba5461ad08e8d8935066dc3987578676069822fbc6b4f397c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db02f4f492da359743cc90b9f4a545981ff43249e1cb32829f0d49b127098da5"
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
