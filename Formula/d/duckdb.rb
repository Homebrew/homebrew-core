class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v1.5.5",
      revision: "d8cdaa33fda8df955cc76ef58a280f68f4cd43fa"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ce2c29e9534404052072cfb6a3a01b384c00ad69484285fc0779e05acb1ff0b7"
    sha256 cellar: :any, arm64_sequoia: "7749ce1d58110b2ac15690d2a6a0d95926e47f60206327ba92142a0dcb5d1a56"
    sha256 cellar: :any, arm64_sonoma:  "696d9997a895034d76ce44d30a6d34df67b8c66d93857a4070f6a69ad587d46b"
    sha256 cellar: :any, sonoma:        "685ef15e1586acbb115664c70b0203df61ef6eb31f8de9d3d66beeded7f07076"
    sha256 cellar: :any, arm64_linux:   "7b90524dd811def9e3b26f707a2d018a2d0844720088129d8e7f2db25efb1ad2"
    sha256 cellar: :any, x86_64_linux:  "6c046cb30353e8879f64066663a4515fb4d6975abc939bdcc9cea173a202ab3d"
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
