class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v1.1.2",
      revision: "f680b7d08f56183391b581077d4baf589e1cc8bd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3a5fc29e2c061fc7248dca65a98cfc36d7f7206a9755e44fd1c7d3b5cc67a88c"
    sha256 cellar: :any,                 arm64_sonoma:  "f119f4590e58df6ab6590e37fb5298f8cb50d9f617561dc57dabefec4bab14e5"
    sha256 cellar: :any,                 arm64_ventura: "faff759a58be0f6f6a324e6032695e5ba19c0e709e09f8b508032981ec987e9d"
    sha256 cellar: :any,                 sonoma:        "bcbeee000919fd49469a608953f62285896baa599ee2ff77b8edf1d6d636e7dc"
    sha256 cellar: :any,                 ventura:       "d4d528c017fc79267aa82960f7f03a6f2c98c9109aaa04d48568b1a8fc60cc99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f3f6f46995bab33a75109ed3b4fe75de52c60a82afec67a47454a3a67214ed5"
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
