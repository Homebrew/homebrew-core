class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.6.0",
      revision: "2213f9c946073a6df1242aa1bc339ee46bd45716"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8ae40f7aa990a7a52e6d230555285d4d174a5bb7535ddd7e54e18e82804a8081"
    sha256 cellar: :any,                 arm64_monterey: "70e3ec7d1d9ea967a8fc345e83bc53966bccea15b24d63f81498e7e0ec6e3f0c"
    sha256 cellar: :any,                 arm64_big_sur:  "c802d1302a8e0d6c33fda447db102bafbecab74e2508f78fe6cc59448378b4f2"
    sha256 cellar: :any,                 ventura:        "0b2ebf6385dbfd682eafb2edc35ae538f32bce73609e188ece2f3e4af801c628"
    sha256 cellar: :any,                 monterey:       "0cd2ea482fb01ea4aab3bd35e01169895ae31ba82f5947a4b24e9b20a22bae99"
    sha256 cellar: :any,                 big_sur:        "9a7b99c6588586d0e9aa4c1388af49e84b67bcb09b65d94ea7f1f654514dca46"
    sha256 cellar: :any,                 catalina:       "1c010a0e17e7f22ba3fadb32b4271b99e97b8489b6a16786087a8f47104df4b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d8b16c2a57cd0b0fab42fa573c863b6ade263725a94f93887552b26757055fe"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  def install
    ENV.deparallelize if OS.linux? # amalgamation builds take GBs of RAM
    mkdir "build/amalgamation"
    python3 = "python3.11"
    system python3, "scripts/amalgamation.py", "--extended"
    system python3, "scripts/parquet_amalgamation.py"
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
