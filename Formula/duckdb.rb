class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/cwida/duckdb/archive/v0.1.8.tar.gz"
  sha256 "18a984e80e14136f6a61f482387a6e159f5cafd256884e66cc21d6d7a511e33c"

  bottle do
    cellar :any
    sha256 "81f1558911cee3b279897c3e37c2a79dcbdfcacfcbfd19867157738a535dabfa" => :catalina
    sha256 "1af4d9657948fde7ee9b755a17af982c06f7b2c37e2d39ba9473964e94c34d21" => :mojave
    sha256 "a7f20ab8f65d30f9159a2ac8ab1c48a589a215a406dae81dde737d3df1040acd" => :high_sierra
  end

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
