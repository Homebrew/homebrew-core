class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/cwida/duckdb.git",
      tag:      "v0.2.3",
      revision: "436f6455f6e48b571bf5ba0812332f08d0bd65f4"
  license "MIT"

  bottle do
    cellar :any
    sha256 "f3cae9c32ad042433dd66119d71b2b344d41af36fa1ce1329fcf285d917605e5" => :big_sur
    sha256 "a082aa7db3bf77040788cc6265f57cc0df1d62844de59cabc20460d9968a0941" => :catalina
    sha256 "14910bb5cebfda1f37a44c76f0ec20d58eda17a02370a8baac926920ffd5485b" => :mojave
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
