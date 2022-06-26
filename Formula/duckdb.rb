class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.4.0",
      revision: "da9ee490df829a96bfbcfcd737f95f8dbc707d0a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "16708c45329391634949ff594dd5537645b96b6097210ef3496ffe3434dc91c5"
    sha256 cellar: :any,                 arm64_big_sur:  "3e9b36be75e00ece879fab0e595f57bf749a5eab481271c76a8b99a5b7dc433d"
    sha256 cellar: :any,                 monterey:       "f0b9d2a1c37e430c86db458d68f83ab2bf25f54479258efdb1df3bd9b5e5959e"
    sha256 cellar: :any,                 big_sur:        "601e5fbbb20b48a99b2ef769ba5b353617f804d6ffdc5e9e1717f00542dae787"
    sha256 cellar: :any,                 catalina:       "7d19e4337901af7f5d7ed0009dbe3db97a7ae58633a8703e66665594337d017b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0834b58ed799b2fe7da2bfb8250099d4cb627c4a2ec58ca455fb6847b733f3f"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  def install
    ENV.deparallelize if OS.linux? # amalgamation builds take GBs of RAM
    mkdir "build/amalgamation"
    system Formula["python@3.10"].opt_bin/"python3", "scripts/amalgamation.py", "--extended"
    system Formula["python@3.10"].opt_bin/"python3", "scripts/parquet_amalgamation.py"
    cd "src/amalgamation" do
      system "cmake", "../..", *std_cmake_args
      system "make"
      system "make", "install"
      bin.install "duckdb"
      # The cli tool was renamed (0.1.8 -> 0.1.9)
      # Create a symlink to not break compatibility
      bin.install_symlink bin/"duckdb" => "duckdb_cli"
    end
  end

  test do
    path = testpath/"weather.sql"
    path.write <<~EOS
      CREATE TABLE weather (temp INTEGER);
      INSERT INTO weather (temp) VALUES (40), (45), (50);
      SELECT AVG(temp) FROM weather;
    EOS

    expected_output = <<~EOS
      ┌─────────────┐
      │ avg("temp") │
      ├─────────────┤
      │ 45.0        │
      └─────────────┘
    EOS

    assert_equal expected_output, shell_output("#{bin}/duckdb_cli < #{path}")
  end
end
