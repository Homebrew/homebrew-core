class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.8.0",
      revision: "e8e4cea5ec9d1a84c1f516d0f0674f8785a3e786"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "adcd3059a22a17ab9ee6d00699cd3f35951edde2252226ac55d92478c1e0423a"
    sha256 cellar: :any,                 arm64_monterey: "ad4d8656c637d05f93143e1fbc9489878c94c757b88974ed5f03f70c064b4002"
    sha256 cellar: :any,                 arm64_big_sur:  "5996ece97e573745eb070289e8674901d431e631b5b508524fac63114388d4c4"
    sha256 cellar: :any,                 ventura:        "82b4e0dad7a26fe04fb6804be25879a1b80f8d4f0939cef4bf81f4386bb665ab"
    sha256 cellar: :any,                 monterey:       "551c9874ac939a94146fbdecc2ef03c942538b02875777d5e7a3171d987ce84e"
    sha256 cellar: :any,                 big_sur:        "88468d2b00af656c3b62aa7a88b8774ff2aa421cea775b87be71596caa697083"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f874c5fd7559eb75dc970fbb52e74d4e3465595ff9dfe126021b8dee3a9deb1c"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build"
    cd "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_ICU_EXTENSION=1", "-DBUILD_JSON_EXTENSION=1",
             "-DBUILD_PARQUET_EXTENSION=1"
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
      ┌─────────────┐
      │ avg("temp") │
      │   double    │
      ├─────────────┤
      │        45.0 │
      └─────────────┘
    EOS

    assert_equal expected_output, shell_output("#{bin}/duckdb_cli < #{path}")
  end
end
