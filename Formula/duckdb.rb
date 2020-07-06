class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/cwida/duckdb/archive/v0.1.9.tar.gz"
  sha256 "235f5b9b39cdbb92de09960c887ad020edad2ad836fb18e19bcc4b11274041cc"
  license "MIT"

  bottle do
    cellar :any
    sha256 "622871609dace070f4c6a655cc3e5e99ec329d0715eb786d81d5adcf779fa041" => :catalina
    sha256 "36ea2f500db65e752921cb0e673c4a50b98eb19647c62c7f440096570391a8e1" => :mojave
    sha256 "efab87265b3c842ff01a6b5e84a734497f552426ad4479f4a6cae6922c3d0827" => :high_sierra
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
    assert_equal "45.0", shell_output("#{bin}/duckdb_cli < #{path}").strip
  end
end
