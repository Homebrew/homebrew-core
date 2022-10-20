class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.5.1",
      revision: "7c111322de1095436350f95e33c5553b09302165"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "953087fe43ee703a442b1d144f380591d073df80f8e748d04fbaf916f6710710"
    sha256 cellar: :any,                 arm64_big_sur:  "b91041089385b41bc40c7fca9bc5756ecbc814bf6badce357032302e4461b620"
    sha256 cellar: :any,                 monterey:       "08e7c05d3f6a127a3d338e642d2f1c2aa12775ba77ece045cfa4386b1424d3ec"
    sha256 cellar: :any,                 big_sur:        "63505a5a33d3cf690863092aa3fadcdcd54f9fb46c8d7830423990a73afb3fc1"
    sha256 cellar: :any,                 catalina:       "8d8874af6551e230ff6297ae27305fcb08089e4bad00986fb29c7f34a68bfc4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42a8c825303877ba1b9fa835aa8e06cc1ea50dece38262b8bb9a2817df4aeb93"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  def install
    ENV.deparallelize if OS.linux? # amalgamation builds take GBs of RAM
    mkdir "build/amalgamation"
    python3 = "python3.10"
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
      ├─────────────┤
      │ 45.0        │
      └─────────────┘
    EOS

    assert_equal expected_output, shell_output("#{bin}/duckdb_cli < #{path}")
  end
end
