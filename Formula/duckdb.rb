class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.5.0",
      revision: "109f932c41fba9d61189e01ab0e5496cb9749506"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b01deabb88723b83840595f54bfbe796cdbe8d5ddf8d9bda3e13f82ab09e650b"
    sha256 cellar: :any,                 arm64_big_sur:  "7336c5aceb390577a68431be1176ed6fc2d8383b40e4808521fcf4f04a2cb47b"
    sha256 cellar: :any,                 monterey:       "79545701dc3647210045c427fa4487df8bb6882db4ebebc5602c291c95b13350"
    sha256 cellar: :any,                 big_sur:        "82bc5e789590e0c75bf3191388a09eaa61b1a801da5d11c218fb4606888dc68d"
    sha256 cellar: :any,                 catalina:       "63d281acc5b8f30921831d0ed4ad9001ee4764ed81f5927a377f551fabdc8be4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8543f2e7009379a935fcc42b32508f92514746ae948a33db12fc0665e2736f04"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  def install
    ENV.deparallelize if OS.linux? # amalgamation builds take GBs of RAM
    mkdir "build/amalgamation"
    python3 = "python3.10"
    system python3, "scripts/amalgamation.py", "--extended"
    system python3, "scripts/parquet_amalgamation.py"
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
