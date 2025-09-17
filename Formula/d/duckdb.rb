class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v1.4.0",
      revision: "b8a06e4a22672e254cd0baa68a3dbed2eb51c56e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "88992481a7423c1409f7aa15bc13a65ce7c2ddf11499efb5d34590ba12309381"
    sha256 cellar: :any,                 arm64_sequoia: "5d60b8fef03a82d6a272cb82e4c1d9e5e7c98f44a6f9c996277b520b092d7d23"
    sha256 cellar: :any,                 arm64_sonoma:  "0cbbf2fa2649432f775552dfd332af13e10746e34d8a48a2f71ee6ec0ef70e0a"
    sha256 cellar: :any,                 sonoma:        "014b1ed7fc006a1f9405910b94b5e2963dae0db07f1f3722152e99936e528328"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a50f91d1c34a14a112b38782eb014a08a2c875cb1eaf5f7dfb0bfc21e56ef81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2140851fb8284d8cc41e2fc7428a2683f4fd1adfe7b66a8f011958bd2b41834f"
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
    assert_equal "45.0", shell_output(testpath/"build"/"test")
  end
end
