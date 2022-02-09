class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.3.2",
      revision: "5aebf7dac8378ac4fb31badadf24de0499d86381"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4b2402fd7fe4ce8a9ef239226bf845c856fa837c76e4d136ad1e1ab41fbea661"
    sha256 cellar: :any,                 arm64_big_sur:  "9016048c33fb30ce2396c5eac2cbb0ed7563febae29cf23234e83a382f7f650b"
    sha256 cellar: :any,                 monterey:       "1ceed95af86ddc91242b31d42ff69e6bdf19f055bcf43fdf40ec4630e72004a5"
    sha256 cellar: :any,                 big_sur:        "56868ceb522a9d5ac55f1d76cbb2230fd52386fe146f66dc394cfdea4dac0db6"
    sha256 cellar: :any,                 catalina:       "733bd43a7533d71421bb6d85ccadf1398d72cf725f6f599de5e109c4298b3209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4de55d51dac2a088917b5cc7e732d38cea547df20c7377d74d762d045dcdd63b"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

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
