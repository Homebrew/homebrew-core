class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/cwida/duckdb.git",
      tag:      "v0.2.2",
      revision: "3222accbaf4b2648e5f2b4d3ff99ba26cbf2aba5"
  license "MIT"

  bottle do
    cellar :any
    sha256 "450e925ec6c6bde4befa4e999dc88be06c96baf156b743fd60ac77a0c2a8dc25" => :catalina
    sha256 "38f709bac3c504b5f1fc76e2d3b8df43c10dd25492f457f781181bca309ace58" => :mojave
    sha256 "d13d63bc49a1ba4b27610e3dffd5ec37592dad931f316f863e5e6e883984f817" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  def install
    mkdir "build/amalgamation"
    system Formula["python@3.9"].opt_bin/"python3", "scripts/amalgamation.py"
    cd "build/amalgamation" do
      system "cmake", "../..", *std_cmake_args, "-DAMALGAMATION_BUILD=ON"
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
      ┌───────────┐
      │ avg(temp) │
      ├───────────┤
      │ 45.0      │
      └───────────┘
    EOS

    assert_equal expected_output, shell_output("#{bin}/duckdb_cli < #{path}")
  end
end
