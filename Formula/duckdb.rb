class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/cwida/duckdb.git",
      tag:      "v0.2.7",
      revision: "8bc050d05b25a379efdaa537bd801b712671a83b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c8ae8cb83c0e90060d2404f5484f9a341273430e73fecd83878e71ed408a11d1"
    sha256 cellar: :any, big_sur:       "6db79be340d21aed37a8d10f25d9f8dbcbbb7fea94535037e019cc9de88b58b0"
    sha256 cellar: :any, catalina:      "ee6034cc5856f527c4fc45a55a4a284272e18728ea0407d47f3fa2523b372f1f"
    sha256 cellar: :any, mojave:        "03a8b8f6fa84d2198428ebcfffb3b52590048416bf3bd3484ea0a705e434545c"
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
