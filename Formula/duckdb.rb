class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.2.8",
      revision: "a8fd73b37bfc249b76b2aaa488d52dfdb39bb3d9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "7d3a59d4b2acfab03cb9926147a94a6a4a36ef663d8fd45fab7f09a520da3d10"
    sha256 cellar: :any,                 big_sur:       "a5243f119762b2ace9e5f6709d81773aa9a296653d78feb1ffb9bc7795fa1be9"
    sha256 cellar: :any,                 catalina:      "1563139761b87e9dacb1e191af79f5f74f484fc2200d25b9305bd1915f851b65"
    sha256 cellar: :any,                 mojave:        "9d6335ff01a65260c95a0c75df6079fa003b529e8a3c513a65cad10b1039dde4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a7fff81c22eeb1a2e4e53dbf09a8f718687cc3078604caeb6fec0142baf4611"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build
  depends_on "utf8proc"

  def install
    on_linux do
      ENV.deparallelize # amalgamation builds take GBs of RAM
    end
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
