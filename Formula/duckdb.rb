class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.3.2",
      revision: "5aebf7dac8378ac4fb31badadf24de0499d86381"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "c07a6abae9638a85c29ae922971822e38f701d534b45891d6f30b9245d0a596e"
    sha256 cellar: :any,                 arm64_big_sur:  "661c449ddd0a85274cc67ee13e3f879bfcabe230eeda89eecf7efe872b2a7a61"
    sha256 cellar: :any,                 monterey:       "7aa321e06da4a0da135725d1ae7abf488355e8da4fbc5aacd644e25947329acf"
    sha256 cellar: :any,                 big_sur:        "eeb0655de2512da9dc757c0b1db4dfe8d9a01318a57edb78b1a1dbf3ee7d7d23"
    sha256 cellar: :any,                 catalina:       "e1b1b561d7b1e90b19d97ec92540d62569534b710ef78910513703ec4feb8261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b995635848717ace446342a51e8c2d6d25140ad282ac9fd5a5f56abce68011e8"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build
  depends_on "utf8proc"

  def install
    ENV.deparallelize if OS.linux? # amalgamation builds take GBs of RAM
    mkdir "build/amalgamation"
    system Formula["python@3.10"].opt_bin/"python3", "scripts/amalgamation.py", "--extended"
    system Formula["python@3.10"].opt_bin/"python3", "scripts/parquet_amalgamation.py"
    cd "src/amalgamation" do
      system "cmake", "../..", *std_cmake_args
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
