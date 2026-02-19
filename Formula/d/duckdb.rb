class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v1.4.4",
      revision: "6ddac802ffa9bcfbcc3f5f0d71de5dff9b0bc250"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "abf9ba5df7e10eee5d3441f7f4b33702d871eaa0e63d19593209c2435f8177a8"
    sha256 cellar: :any,                 arm64_sequoia: "0ece4a1649bdae5378b38f3c42cd570a416716fa902792f7c89576d7d9193f8b"
    sha256 cellar: :any,                 arm64_sonoma:  "f15731d97512b85060aa54fe1ea330aee6827ce30f8b3dc9afbbb38db6efa5a6"
    sha256 cellar: :any,                 sonoma:        "2535bb449d5fcfa2a6550310c1b083ec51df51d307ee09dcb3d57e6e01ef27ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33371e48153e2bab2dd601f24992193a5d98ae4748d2a207dba3e3b6b5573552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4780e4250f5b7e23b6441ae983f1092fe734c0a9b3b8a8bef6e348970a971670"
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
