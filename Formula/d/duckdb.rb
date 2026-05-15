class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v1.5.2",
      revision: "8a5851971fae891f292c2714d86046ee018e9737"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c84e6cadf80cacb43a7d1c2820d2d8adaddad82d67dcb6aee695f8b3c1e40a2c"
    sha256 cellar: :any,                 arm64_sequoia: "e470c54cdc0a13db10601189a6a42a1ad1382d8e338da7b153fcc9744b0ac3b1"
    sha256 cellar: :any,                 arm64_sonoma:  "47422480d92abf39c5ff88a465b7a8c728682dce8e969dd4b0b77c86f8952d20"
    sha256 cellar: :any,                 sonoma:        "fb9f73daf067a815daed3fea428c7fdf50ea4678b02dbaed0f1539e0d24208c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4167492330f96a21b993c53fa7068b2ee2fdde69c8a61cd278a06f9129a3f815"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fd7088180ef50fdce54cfec42cf9a5cf6c2c70d0aa8d328a7088e9eb80a8e48"
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
