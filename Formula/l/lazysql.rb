class Lazysql < Formula
  desc "Cross-platform TUI database management tool"
  homepage "https://github.com/jorgerojas26/lazysql"
  url "https://github.com/jorgerojas26/lazysql/archive/refs/tags/v0.4.8.tar.gz"
  sha256 "bc6f00759376a30cbeb28af3200a0df2ab3df07f41717be2cf08122827e1671f"
  license "MIT"
  head "https://github.com/jorgerojas26/lazysql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21e8091f4b59cf599cec6bcbd323c2825350577373d3930b0824ec0ed09d9050"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21e8091f4b59cf599cec6bcbd323c2825350577373d3930b0824ec0ed09d9050"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21e8091f4b59cf599cec6bcbd323c2825350577373d3930b0824ec0ed09d9050"
    sha256 cellar: :any_skip_relocation, sonoma:        "c981b5288659a472d370bc1bc6c7f8b98a01d2ce902f61380e19c8ba013f5540"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "807b7ea9ec4d09264eb5c08226debf956a61654663ba7cba3bdd473e95479583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a933b0b3e60b99dd02c9c1771d204e3f5be1a2bb9939d1d08f6646bb4430722"
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
