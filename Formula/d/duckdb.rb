class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v1.4.2",
      revision: "68d7555f68bd25c1a251ccca2e6338949c33986a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ec85d161dc863aefdfe3bd17c2d072ffc553a72f69c672a752ca2345a7f2b59f"
    sha256 cellar: :any,                 arm64_sequoia: "7125d2e18bf5cc17cf654ab03383457f57decbf7d9bdf9e8ac32b1f515c19dbf"
    sha256 cellar: :any,                 arm64_sonoma:  "d0efbc6339aef9b79f9098325bc8f74d5b82ed2acce34b35dbb3fbcface21551"
    sha256 cellar: :any,                 sonoma:        "f7a61c72868b089884e1e549e96eaff17ea2d2d2ac75cfa4c7edc9b9f5ebc830"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6eb0afdcc98084fd4776aa5a6108e0a36ab7f5069efc4e07a18f72a74b16642"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "356cdd10622e15cc2a411a27ddf8d4c0df6c315799f4cbedb0551dfc6e566567"
  end

  depends_on "cmake" => [:build, :test]
  uses_from_macos "python" => :build

  def install
    args = %w[
      -DBUILD_EXTENSIONS='autocomplete;icu;parquet;json'
      -DENABLE_EXTENSION_AUTOLOADING=1
      -DENABLE_EXTENSION_AUTOINSTALL=1
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # The cli tool was renamed (0.1.8 -> 0.1.9)
    # Create a symlink to not break compatibility
    bin.install_symlink bin/"duckdb" => "duckdb_cli"
  end

  test do
    sql_commands = <<~SQL
      CREATE TABLE weather (temp INTEGER);
      INSERT INTO weather (temp) VALUES (40), (45), (50);
      SELECT AVG(temp) FROM weather;
    SQL

    expected_output = <<~EOS
      ┌─────────────┐
      │ avg("temp") │
      │   double    │
      ├─────────────┤
      │        45.0 │
      └─────────────┘
    EOS

    assert_equal expected_output, pipe_output(bin/"duckdb_cli", sql_commands)

    (testpath/"test.cpp").write <<~CPP
      #include "duckdb.hpp"
      #include <iostream>
      using namespace duckdb;
      int main() {
        DuckDB db(nullptr);
        Connection con(db);
        con.Query("CREATE TABLE weather (temp INTEGER)");
        con.Query("INSERT INTO weather (temp) VALUES (40), (45), (50)");
        auto result = con.Query("SELECT AVG(temp) FROM weather");
        std::cout << result->Fetch()->GetValue(0, 0).ToString();
      }
    CPP

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(test_duckdb)
      set(CMAKE_CXX_STANDARD 11)
      find_package(DuckDB REQUIRED)
      add_executable(test test.cpp)
      target_link_libraries(test duckdb)
    CMAKE

    system "cmake", "-S", testpath, "-B", testpath/"build"
    system "cmake", "--build", testpath/"build"
    assert_equal "45.0", shell_output(testpath/"build/test")
  end
end
