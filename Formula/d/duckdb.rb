class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.10.2",
      revision: "1601d94f94a7e0d2eb805a94803eb1e3afbbe4ed"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "78ac19d61f3e987dd62ff410fff2a8538d1f7a7872097ed04e1b0783232fc79f"
    sha256 cellar: :any,                 arm64_ventura:  "34878da351d28f3a2d16620b315fbed1b15277cea2074e3bf42279e2d215bea3"
    sha256 cellar: :any,                 arm64_monterey: "8fdd40597ae92745e6393747050881231fb1525fe7c0238cb7f18bcf4c66f6e3"
    sha256 cellar: :any,                 sonoma:         "b3199306567c564d620f5530f7c1647449e00a6a6d34f4bb69209211ac275c55"
    sha256 cellar: :any,                 ventura:        "2313efdfe9376a39a13d83e8a08b1ecdfb870b1b6b0dab6119d171ae8ae67f60"
    sha256 cellar: :any,                 monterey:       "8a66f5ff68b0bcfd7cbd92bccea9edc4ff20a5fd7fa3759b950053a9c3e86939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3afe1f9acd784aa6f12123436e3648d5d6a33abfd5c368cd8619e42b4db6d2c"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  def install
    args = %w[
      -DBUILD_EXTENSIONS='autocomplete;icu;parquet;json'
      -DENABLE_EXTENSION_AUTOLOADING=1
      -DENABLE_EXTENSION_AUTOINSTALL=1
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # The cli tool was renamed (0.1.8 -> 0.1.9)
    # Create a symlink to not break compatibility
    bin.install_symlink bin/"duckdb" => "duckdb_cli"
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
