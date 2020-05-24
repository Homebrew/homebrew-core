class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/cwida/duckdb/archive/v0.1.7.tar.gz"
  sha256 "07b6db4512cf41647043160dc64dfd919948ca7f96c31c1085ce2c79e2059a1c"

  depends_on "cmake" => :build
  depends_on "python@3.8" => :build

  def install
    mkdir "build/amalgamation"
    system Formula["python@3.8"].opt_bin/"python3", "scripts/amalgamation.py"
    cd "build/amalgamation" do
      system "cmake", "../..", *std_cmake_args, "-DAMALGAMATION_BUILD=ON"
      system "make"
      system "make", "install"
      bin.install "duckdb_cli"
    end
  end

  test do
    path = testpath/"weather.sql"
    path.write <<~EOS
      CREATE TABLE weather (temp INTEGER);
      INSERT INTO weather (temp) VALUES (40), (45), (50);
      SELECT AVG(temp) FROM weather;
    EOS
    assert_equal "45.0", shell_output("#{bin}/duckdb_cli < #{path}").strip
  end
end
