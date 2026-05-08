class Lazysql < Formula
  desc "Cross-platform TUI database management tool"
  homepage "https://github.com/jorgerojas26/lazysql"
  url "https://github.com/jorgerojas26/lazysql/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "64234607848634342e1b98788f331f5908cfb27b93acaa5341d88e0a465cf464"
  license "MIT"
  head "https://github.com/jorgerojas26/lazysql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "789ee2f436e90b5940efdc8a24dfc583577b09193955c7b72463e91c63d30e92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "789ee2f436e90b5940efdc8a24dfc583577b09193955c7b72463e91c63d30e92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "789ee2f436e90b5940efdc8a24dfc583577b09193955c7b72463e91c63d30e92"
    sha256 cellar: :any_skip_relocation, sonoma:        "9dfa968c73b9fe7dc6de239fa78a28eed1ab94977ab8f73d8204ac3f18de4b84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13c18305281a24c94436def6af52684f5fade7790e8524ac013629c26c300e6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bed219709a61ffd873b035081916fa9dd97ef46e745017093188ff464f813471"
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
