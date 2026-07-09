class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v1.5.4",
      revision: "08e34c447bae34eaee3723cac61f2878b6bdf787"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "db9acb5a1c5b6282097cd481b70fe7b94f2eb98ef822876f06a3d4469fd9a62b"
    sha256 cellar: :any, arm64_sequoia: "c83ad7b96cbc303f8c0dd06b67af019b7655267522344ee3f45554a9818f8b81"
    sha256 cellar: :any, arm64_sonoma:  "04f9615a686180d399431641b6fd7ce349f035fa0d3b23227affc37143fc9f38"
    sha256 cellar: :any, sonoma:        "d29345164842526038ec2962549a214e068aa8a2b1537883dca33bb3b8cf9fc8"
    sha256 cellar: :any, arm64_linux:   "0056cc2776aa2406a1af1c998e6dcad54fe51da54a1cf86408d9ae76ce133ab3"
    sha256 cellar: :any, x86_64_linux:  "3b3de5b06972b029591213582f92a1d84b6f77ee7098ea335a8bfcdb7442c862"
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
