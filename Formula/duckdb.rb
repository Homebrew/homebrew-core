class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.7.1",
      revision: "b00b93f0b14bfff869e1facfd86a6b556a6f1c6e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4c9561b82d613ed2eb59716d5f99ad7a7a24011eedb2c21234d1f47985376cb7"
    sha256 cellar: :any,                 arm64_monterey: "38edf75cac22b89858013b3735c6d84b0e185e58d168e18a35d4b9b2eb076b72"
    sha256 cellar: :any,                 arm64_big_sur:  "599848c4bdae7f847bb6e383ff7f9dc558893789540babae0d76927b391403ae"
    sha256 cellar: :any,                 ventura:        "bbf0b3048b3cea604ca700876c4d77431debaaf3c2ef3b417737a88b374a26bc"
    sha256 cellar: :any,                 monterey:       "ff875bdebba7d54eb0a5935f70c8813d816980f364f47b3e073d8544bbcaebc2"
    sha256 cellar: :any,                 big_sur:        "fc6c046a7ac940a57e540314c4ffc0baa2075694e2cd948afc9833956f287745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91001b67511feeda3325d193dee4c5947e9096e22a7c649faa6779d0225c2e08"
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
