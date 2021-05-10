class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/cwida/duckdb.git",
      tag:      "v0.2.6",
      revision: "8295e245d59c471bdd1a1bea27e7f04333c212b0"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "af129c44a8fbdfbee227e27175e6d36924bc38b9b0561dc37f22640432dc8a5e"
    sha256 cellar: :any, big_sur:       "487edb3243770fbee6104c74dbd98dbe65e1fa6db917dc532a82dfca8e93fcd3"
    sha256 cellar: :any, catalina:      "9bfe7742ec2fccecdd3a0a3bfc43008b353dad093d79bda164aa81b70e6f204b"
    sha256 cellar: :any, mojave:        "2b8e9c06f8c7781a705f7d09fbce4e8c1da878a52f7e11548e08d7d5d8fb6174"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  def install
    mkdir "build/amalgamation"
    system Formula["python@3.9"].opt_bin/"python3", "scripts/amalgamation.py"
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
