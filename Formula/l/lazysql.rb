class Lazysql < Formula
  desc "Cross-platform TUI database management tool"
  homepage "https://github.com/jorgerojas26/lazysql"
  url "https://github.com/jorgerojas26/lazysql/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "7d4a1b2f819c8c78c72a885e1c4642c3d1d520bcddbf6bee63a311e798a0d77b"
  license "MIT"
  head "https://github.com/jorgerojas26/lazysql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfd4086ca7652e4ec16a871d4e2a572bf837da833956655db64488b981685cc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfd4086ca7652e4ec16a871d4e2a572bf837da833956655db64488b981685cc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfd4086ca7652e4ec16a871d4e2a572bf837da833956655db64488b981685cc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "9410dd5929e2a2a33ba12cdab228edfe081a683ebaf346f1c0f4377e97bdd62e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd8c75779fd26b1df932d3f5f888d5615f9af642a977c86b77a40412686e610e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a511db61ab7e9c8c041b1ce4ee0aa401efbbf6439264316a951a8a314e16d2f8"
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
