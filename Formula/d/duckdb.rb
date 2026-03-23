class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v1.5.1",
      revision: "7dbb2e646fea939a89f10a55aa98c474cbb0c098"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7a1cdb074d41f998cf969283b961cec0428dcc0c6b9f14a6709c9fde1346eab5"
    sha256 cellar: :any,                 arm64_sequoia: "351fab37d0ffe5f76c559be84db9bb5bba4e3bf8e627412e6889ce2b8c782a3d"
    sha256 cellar: :any,                 arm64_sonoma:  "0c1b1d4577522049041bf4a99b3b8a5ea1253c8f2e97e6a309b2095908775d9e"
    sha256 cellar: :any,                 sonoma:        "c658bebe1dff43ec9a07850e9f13bf02c07887b89b3686e9339d57a1ceb9eaee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac022bc078c1b7816301710fa5eb1ac3ffaea4e012f892f191cb7bbd3697cd9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0be19338d545ac9b8182f27bb7bd00060b691e0d66ecdbb6acaa45b57857251"
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
