class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/cwida/duckdb/archive/v0.2.0.tar.gz"
  sha256 "5ed30486f7f9877f5e5d2fd7047347b86fa9ca105e1ed41e53e1fcb4b3f7bc0c"
  license "MIT"

  bottle do
    cellar :any
    sha256 "ac85f387cef72b578652256af88e96a959413e537f0b06ed21ea83cf04c62733" => :catalina
    sha256 "038284bb668179934e71572118c0e06140418bf6cac2318ba0a9c5d7374c59ae" => :mojave
    sha256 "1298a14fca854438e7e2c8882c986a8e7805dfd359ae021d2441e39b52e32a00" => :high_sierra
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
