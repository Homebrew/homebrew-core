class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v2.0.1",
      revision: "8d78114e90a53823803660bf821f6073ac87da8c"
  license "MIT"
  compatibility_version 1

  bottle do
    manifest_sha256 "005ca3f25a6c9ca5e8bbed425e57af0cd9c95cb01fc9f807c5377c2b3fe15750"
    sha256 cellar: :any, arm64_golden_gate: "70366b6021757995ee977924d36a948b40dc748dfc1b53df5d6838dab38dfa6c"
    sha256 cellar: :any, arm64_tahoe:       "4c20b4187aa6a6f0c85d31643cc5b96597a9f7cd7a48855d6f24641cb0b5ed86"
    sha256 cellar: :any, arm64_sequoia:     "ca081c603065488f74c6f8de8d2c7f4a45a873171c8802bd9ef39a45c54da6e7"
    sha256 cellar: :any, arm64_linux:       "f977eeccd9963a88f6f2d32333079fe0e6ab5ac5c3db76b09ec33738be9eb02f"
    sha256 cellar: :any, x86_64_linux:      "a9abc43565b5294032b5dfc251ebad7d326d895aa86ad77cc74fddf5328b9ddd"
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
