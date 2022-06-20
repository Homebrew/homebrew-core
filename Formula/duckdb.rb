class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.4.0",
      revision: "da9ee490df829a96bfbcfcd737f95f8dbc707d0a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5ac818edec1695c29278e57ad3a45ea9eb87be6e3173324e02eb4d7291426ec0"
    sha256 cellar: :any,                 arm64_big_sur:  "47fa2b4d19d1badb42da49c64b736d58e30db52227269edbe9c6967df5657303"
    sha256 cellar: :any,                 monterey:       "6cfb2e1ab4e1d633a1bbab6f11c57e18b2b7bdec6aea030e62f8b9e6ab7df93a"
    sha256 cellar: :any,                 big_sur:        "c49438029913b6fe4b252ebc4a9dacaec989f1818a2f5eec4274520c65ebc56c"
    sha256 cellar: :any,                 catalina:       "4bc94c421c8ae3e3dc16765515daa4fff650ae7f9e64f458570c98e6386dc98c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96da98d417df0acd7cb219ed81d6bb89b841f3f98ae9717fd62002483462ff4b"
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
