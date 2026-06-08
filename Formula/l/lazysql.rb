class Lazysql < Formula
  desc "Cross-platform TUI database management tool"
  homepage "https://github.com/jorgerojas26/lazysql"
  url "https://github.com/jorgerojas26/lazysql/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "be1ec5b79f42e26536189fbd7116e95288ea4b15bf356e14c548e14dd45a3e33"
  license "MIT"
  head "https://github.com/jorgerojas26/lazysql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1b9ffd5789818b6ac7a93261aa54857d0a3bc40845433a3d52fb4e38f1e3894"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1b9ffd5789818b6ac7a93261aa54857d0a3bc40845433a3d52fb4e38f1e3894"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1b9ffd5789818b6ac7a93261aa54857d0a3bc40845433a3d52fb4e38f1e3894"
    sha256 cellar: :any_skip_relocation, sonoma:        "c140b1055379b3efa5d5d7615cdf5250790b043ee50faf26b5d9e84df06f7787"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae2e7836c139d8993089469a44ff9fff869baa4466cc80d010ae9238aa670ca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c457cdf07a59142ab672ccad31e611767d1acb6bd160e7324383457bec0aa40"
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
