class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v1.5.0",
      revision: "3a3967aa8190d0a2d1931d4ca4f5d920760030b4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "460574aae27f864b408ad3bc0eb7e5a1a47f6421c76acfd68113404db3f6beb8"
    sha256 cellar: :any,                 arm64_sequoia: "3cd0a6bbf884234fede6c2fb75ed4c329ae97b50f164a8ba2b41e418622a36e7"
    sha256 cellar: :any,                 arm64_sonoma:  "49e638f4069139eeecdcff5fb6d9e6a0a10fac5ace267160c6fecb39492f3012"
    sha256 cellar: :any,                 sonoma:        "28ded1a99085bd02bcb288ba560f6c716eae66ada8fe2b5669fc43c13df52d89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "032a239600bc585c1a4209a8f1809c259a8137541d5fa8ac052719c447f5840e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "381e0e85f47e1fb90cce472329c30631a7aa88a3bc3f756b3702c9dc4970f47e"
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
