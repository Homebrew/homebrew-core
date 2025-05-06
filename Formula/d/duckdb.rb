class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v1.2.2",
      revision: "7c039464e452ddc3330e2691d3fa6d305521d09b"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "08f736ac15900c9419d502cd49a561b00654ca43c1fb537477dd902386b87905"
    sha256 cellar: :any,                 arm64_sonoma:  "b2944c5b262da44b7c220ee8e088623341845ae625140c80f381b891d5b0cdd9"
    sha256 cellar: :any,                 arm64_ventura: "b757097a4f3e3987d271e0af6087d7ebd56ad78c3f197e08bf66f5477ed89552"
    sha256 cellar: :any,                 sonoma:        "c6a941d6bf421faaeaea61d0575aba122b98481a64d908855819481cc445abf1"
    sha256 cellar: :any,                 ventura:       "4ca934eb3dc7d50b575aab4905cdfe5325c7974087a6e25a800d3c95e0190e13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7eebc76d2395b6b97c28cfe6574a9b4892fce2b55bb2bcc4aa1b21060dd8d75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc7d56badae2ff05853832413a614da1185060fa501a74b25b35511fa404c86e"
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

    rm lib.glob("*.a")
  end

  test do
    path = testpath/"weather.sql"
    path.write <<~SQL
      CREATE TABLE weather (temp INTEGER);
      INSERT INTO weather (temp) VALUES (40), (45), (50);
      SELECT AVG(temp) FROM weather;
    SQL

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
