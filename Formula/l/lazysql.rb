class Lazysql < Formula
  desc "Cross-platform TUI database management tool"
  homepage "https://github.com/jorgerojas26/lazysql"
  url "https://github.com/jorgerojas26/lazysql/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "849cfe4ffa60173903f2e053820e6d9e41c654ea193bdd5466774e114f4d28d3"
  license "MIT"
  head "https://github.com/jorgerojas26/lazysql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e8409c5fe9b4f71ddf4b9c4e228033201f5d00b9ff0b793b77fd620f82c0656"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d65ce1718770d13839f9c33a4d4e52a33bfc12839abe9e8fc2d86c6604915d3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d65ce1718770d13839f9c33a4d4e52a33bfc12839abe9e8fc2d86c6604915d3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d65ce1718770d13839f9c33a4d4e52a33bfc12839abe9e8fc2d86c6604915d3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e90f42c011395437ac73cac71ffba446e1766b17cc8da703a715a070a7cd2ff"
    sha256 cellar: :any_skip_relocation, ventura:       "4e90f42c011395437ac73cac71ffba446e1766b17cc8da703a715a070a7cd2ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02e15c1975d6114f85fe29c30fee2c06a8cd72329d6031193244f48bfbf7a873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a890aadb0eacadb780951ea4b37b4c17206d90380cbece2066133c7e5e98a50"
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
