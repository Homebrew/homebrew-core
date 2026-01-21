class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v1.4.3",
      revision: "d1dc88f950d456d72493df452dabdcd13aa413dd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aeedf85a92da7734c7c4fe46da8560e6c786cb021c7afd92d2799b44bb00a658"
    sha256 cellar: :any,                 arm64_sequoia: "5c76937a5f4e46bcdd0bb8f9154e41a4a0152dd50d6b9c021253d4983b5b4042"
    sha256 cellar: :any,                 arm64_sonoma:  "cbde8ad2a8fd55f4f1fea3bfb428762d5c3b7de2e207d6f0da879f4a69acc716"
    sha256 cellar: :any,                 sonoma:        "ac968a32a2d759460c448b5bc4f6c255010cc7bdbd50d6b2ec05347578fa460b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d347da14a6cb109b9460f162ad068afb104932d52541edfac1b3957e4531a48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b76b10577f82d883055dec245d77ec7224a74a0a4067084b75249a74217be1d3"
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
