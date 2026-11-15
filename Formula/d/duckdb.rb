class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v2.0.0",
      revision: "d54cbbe3df17e8e5ce68312f483b4155836112aa"
  license "MIT"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4b006cf962ebd7866ece8785e60ee5851edd903a224bcd83de91ab5d2dec5784"
    sha256 cellar: :any, arm64_tahoe:       "6144eed8854d78e66c78bc202e69468ff75d3ded241e6bfa2bb141c9f76f8da2"
    sha256 cellar: :any, arm64_sequoia:     "dc55e876d1c2af3c8a1929dc823979fd0bc06214b89b51d30b3769b7438a7ebd"
    sha256 cellar: :any, arm64_linux:       "b57d970696ed476287fc7bd002c23646fe6488735ac17ba1bd6550c93d32bbc6"
    sha256 cellar: :any, x86_64_linux:      "622a11d549e87cfc1746006ee8c7909db6c6c4a9d3370734173251616a2f0cd8"
  end

  depends_on "cmake" => [:build, :test]
  uses_from_macos "python" => :build

  deny_network_access!

  def install
    # See https://github.com/duckdb/duckdb/blob/v2.0-cyanoptera/.github/workflows/OSX.yml#L24
    args = %W[
      -DOVERRIDE_GIT_DESCRIBE=v#{version}
      -DBUILD_EXTENSIONS='autocomplete;icu;parquet;json'
      -DLINK_CORE_EXTENSIONS=1
      -DDUCKDB_CAPABILITIES=httplib;loadable_extensions
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
    # a release build must report the tagged version, not a -dev build
    assert_match "v#{version} ", shell_output("#{bin}/duckdb --version")
    refute_match "-dev", shell_output("#{bin}/duckdb --version")

    # the extensions named in BUILD_EXTENSIONS must be linked in, not merely built
    linked_sql = "SELECT extension_name FROM duckdb_extensions() " \
                 "WHERE install_mode = 'STATICALLY_LINKED' " \
                 "AND extension_name IN ('autocomplete', 'icu', 'json', 'parquet') ORDER BY 1"
    assert_equal "autocomplete\nicu\njson\nparquet\n",
                 shell_output("#{bin}/duckdb -csv -noheader -c \"#{linked_sql}\"")
    autocomplete_sql = "SELECT suggestion FROM sql_auto_complete('SEL')"
    assert_match "SELECT", shell_output("#{bin}/duckdb -csv -noheader -c \"#{autocomplete_sql}\"")

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
      set(CMAKE_CXX_STANDARD 17)
      find_package(DuckDB REQUIRED)
      add_executable(test test.cpp)
      target_link_libraries(test duckdb)
    CMAKE

    system "cmake", "-S", testpath, "-B", testpath/"build"
    system "cmake", "--build", testpath/"build"
    assert_equal "45.0", shell_output(testpath/"build/test")
  end
end
