class Lazysql < Formula
  desc "Cross-platform TUI database management tool"
  homepage "https://github.com/jorgerojas26/lazysql"
  url "https://github.com/jorgerojas26/lazysql/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "de14848d91db3bd70dac399030fd7f5053b8fd6479d2b15fdafcda03ff136724"
  license "MIT"
  head "https://github.com/jorgerojas26/lazysql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f80bf40ed7c5573d1fc5c22026043110c1820cf02274dcf7d434f3829d17252f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f80bf40ed7c5573d1fc5c22026043110c1820cf02274dcf7d434f3829d17252f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f80bf40ed7c5573d1fc5c22026043110c1820cf02274dcf7d434f3829d17252f"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb4e54f06a410993248d8f300f67da31a84e31976d899eda2872df2fe2405f9f"
    sha256 cellar: :any_skip_relocation, ventura:       "cb4e54f06a410993248d8f300f67da31a84e31976d899eda2872df2fe2405f9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "680e0bf2cdf005493e942aa6460d453dc2e697259f86317272d1517c04155428"
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
