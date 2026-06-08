class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v1.5.3",
      revision: "14eca11bd9d4a0de2ea0f078be588a9c1c5b279c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "142d8b6b3d9ce5320252a5b8600782bd540b42973e19b4f3025d26ff30cf7e4a"
    sha256 cellar: :any,                 arm64_sequoia: "d4749c860fca5d64bd87dfb12c3e7406f1feaa2be49cd4d500332fa781e1a4ca"
    sha256 cellar: :any,                 arm64_sonoma:  "88c27256b705380230f7f9bb757446bb67f76b32b6bb197f2b71b045b9314f7f"
    sha256 cellar: :any,                 sonoma:        "9e0c2c989de14973e6ecb292e03eddea87b36b142470ecf97dd3343899aa084b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90f29ce91df6874aac25bd00bc9163eda355d5a88ee770657735802696e4d234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c045e31e657bcb225582105eeaa0573debd9b59a98a0315c2fac8cee16087c6a"
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
