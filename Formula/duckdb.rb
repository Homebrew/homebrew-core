class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.2.9",
      revision: "1776611ab8770d934f44dd9c8c2ac96f743408a9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "4690ac3b2e1a9ad6b2b649f302a7cc263da0f075f10c3370f294c096babbc4b4"
    sha256 cellar: :any,                 big_sur:       "53f34d296151b18be3ec75961e15d7099f5bc90eebecd6fe5a3d376f7de20b2c"
    sha256 cellar: :any,                 catalina:      "19149ad12f65d6c161ad2b4a6d75bfc7bd40dccb0fbab75dfcbb0a6659d7a2d4"
    sha256 cellar: :any,                 mojave:        "481aa4c9fac1c84a6aae4ab6c3897d95bd59cdf0ac69b9773429eedbf92ba109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b5d3e1d8858ac59d47749baf3c3f5fae22ccdd703c937bf9bdf012fb0a69be3"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build
  depends_on "utf8proc"

  def install
    ENV.deparallelize if OS.linux? # amalgamation builds take GBs of RAM
    mkdir "build/amalgamation"
    system Formula["python@3.9"].opt_bin/"python3", "scripts/amalgamation.py", "--extended"
    cd "build/amalgamation" do
      system "cmake", "../..", *std_cmake_args, "-DAMALGAMATION_BUILD=ON"
      system "make"
      system "make", "install"
      bin.install "duckdb"
      # The cli tool was renamed (0.1.8 -> 0.1.9)
      # Create a symlink to not break compatibility
      bin.install_symlink bin/"duckdb" => "duckdb_cli"
    end
  end

  test do
    path = testpath/"weather.sql"
    path.write <<~EOS
      CREATE TABLE weather (temp INTEGER);
      INSERT INTO weather (temp) VALUES (40), (45), (50);
      SELECT AVG(temp) FROM weather;
    EOS

    expected_output = <<~EOS
      ┌───────────┐
      │ avg(temp) │
      ├───────────┤
      │ 45.0      │
      └───────────┘
    EOS

    assert_equal expected_output, shell_output("#{bin}/duckdb_cli < #{path}")
  end
end
