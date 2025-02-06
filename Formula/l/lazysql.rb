class Lazysql < Formula
  desc "Cross-platform TUI database management tool"
  homepage "https://github.com/jorgerojas26/lazysql"
  url "https://github.com/jorgerojas26/lazysql/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "b8f725e7e3e26e4d8c90f5ce5f336f8916f9dfdeb9468736c7d8a2b3a970498c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b39c736b95ed324b0cdf0053829afbda0796b858b70b43d1f1a1233b00c0960e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b39c736b95ed324b0cdf0053829afbda0796b858b70b43d1f1a1233b00c0960e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b39c736b95ed324b0cdf0053829afbda0796b858b70b43d1f1a1233b00c0960e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2c989d974d85f2bf369c684e86e31e83e83d86a2a0f70dea8593c9a5df605b8"
    sha256 cellar: :any_skip_relocation, ventura:       "b2c989d974d85f2bf369c684e86e31e83e83d86a2a0f70dea8593c9a5df605b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a017abc286d60d26ad804e35f22da4aeba2c0c01ae3fb4bf6e11d5f7459417b"
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
