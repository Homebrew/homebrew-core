class Lazysql < Formula
  desc "Cross-platform TUI database management tool"
  homepage "https://github.com/jorgerojas26/lazysql"
  url "https://github.com/jorgerojas26/lazysql/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "b085be3949159dfc870f710e7910ce185ceb5ef508c517ab0e50bf5e8d76c095"
  license "MIT"
  head "https://github.com/jorgerojas26/lazysql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b90e7adcc45196c63ea7769a27e696bb658299915208d1151b94f2a4c07c61a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b90e7adcc45196c63ea7769a27e696bb658299915208d1151b94f2a4c07c61a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b90e7adcc45196c63ea7769a27e696bb658299915208d1151b94f2a4c07c61a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d230c6b720e12d786139813b8265aec065d2e1828560e89cda8f481a24b6c80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1da3962e3070d0b186d78ab3ef85352bcd65f926fcb6e2d5c202e9535e874a3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aed565ad67960bb85d4a18290628e5e0ac5f9d98553aec331d5c04585dc9547f"
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
