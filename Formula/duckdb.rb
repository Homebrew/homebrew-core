class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/cwida/duckdb.git",
      tag:      "v0.2.1",
      revision: "d9bceddc7209a7e0b5c0402958d1191e19a491e7"
  license "MIT"

  bottle do
    cellar :any
    sha256 "a2bf08b307b78aa2ea059ac77093531debe2434922a2e1f0afbc7a820e989302" => :catalina
    sha256 "dbbb8667bca6338b00b9d02f1b8eab5b900fc856a1c4ee1b68916790c0da4242" => :mojave
    sha256 "320e691b9b23b3748c56f046eee12b648769a6e8563d1eebec2e330258a0a48b" => :high_sierra
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
