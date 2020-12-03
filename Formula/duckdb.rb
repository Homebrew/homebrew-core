class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/cwida/duckdb.git",
      tag:      "v0.2.3",
      revision: "436f6455f6e48b571bf5ba0812332f08d0bd65f4"
  license "MIT"

  bottle do
    cellar :any
    sha256 "8b5a9b4cb61a047a1bbfd622f26e657db98eb549ef21b53de6845761b8390748" => :big_sur
    sha256 "b3928bdf9934279b10485a29ad3e7279ccfc12118d713fd23e3d287a01b4cf0f" => :catalina
    sha256 "b42c5e39ae23a9b460569cfec630c93d8758e073941952acf617e859bba5c62d" => :mojave
    sha256 "7395d6ce40323f839ee50d599abafbee2ed0e24d0429e69363d754841ebe085a" => :high_sierra
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
