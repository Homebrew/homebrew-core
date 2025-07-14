class Lazysql < Formula
  desc "Cross-platform TUI database management tool"
  homepage "https://github.com/jorgerojas26/lazysql"
  url "https://github.com/jorgerojas26/lazysql/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "9601618df5aad0d4e94ebb963df77336f17490000dcceb6b70f899ee0abb66c1"
  license "MIT"
  head "https://github.com/jorgerojas26/lazysql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5fd0cc8cb897d10abcccebf1f1472dd1652d217a0fa6136c3941f4b777d9810"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5fd0cc8cb897d10abcccebf1f1472dd1652d217a0fa6136c3941f4b777d9810"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5fd0cc8cb897d10abcccebf1f1472dd1652d217a0fa6136c3941f4b777d9810"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bcb02802c9037ab56f0d65725493dc7020963d336ac5cb5e7639edbdbb61396"
    sha256 cellar: :any_skip_relocation, ventura:       "7bcb02802c9037ab56f0d65725493dc7020963d336ac5cb5e7639edbdbb61396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3189401f538f5457498bbbe1ee0beccef6e8745c7dd80a926303dd4e85a0e37d"
  end

  depends_on "go" => :build
  uses_from_macos "sqlite" => :test

  def install
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
