class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.8.1",
      revision: "6536a772329002b05decbfc0a9d3f606e0ec7f55"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7285e35f75dcc9445ce051ed160e3e598dce1928958ba576597f7594f1a91e6e"
    sha256 cellar: :any,                 arm64_monterey: "6d2dbd766cdd3b3d0f5efae4a6b0a84f954a37dca404ff90341118c3bfe48091"
    sha256 cellar: :any,                 arm64_big_sur:  "2eacb6a11d23d169773ff5cdcdd58902da5b8e0750046fbb8bc31096e5e1a935"
    sha256 cellar: :any,                 ventura:        "18eb3e511611edc32910d442f723dfb80275945f329fb1863eed9c618dbb43d6"
    sha256 cellar: :any,                 monterey:       "1506500f6ed51cc029bd46c8448a21e9f499d8e2339be179ca40e7a0b907a780"
    sha256 cellar: :any,                 big_sur:        "e121ad95a43e8d875e82fb0e01da4aade5315670ad4f1f3f5cb73742f1da9ee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f758dff6e407bbf618cb9d0d37fd84f65718188d1d559d1977f27fc5846e4e2a"
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
