class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v1.2.0",
      revision: "5f5512b827df6397afd31daedb4bbdee76520019"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "67d42c867049045ad8ec4b2fe8cb0fe3d25c19ca35f38df06d5495e6706f8b27"
    sha256 cellar: :any,                 arm64_sonoma:  "94a5719f7dd2db40bb656c1daf9ec76c172e5d8acab8b672127f9f69e32b54ab"
    sha256 cellar: :any,                 arm64_ventura: "162248ab916eae4cbd598ccb9965a2d1e68494bca6501c291eb3730739435990"
    sha256 cellar: :any,                 sonoma:        "e052183aac83bd8cb8cd8a7768253d03a209b1964ec75e768c64ba12c28a88cb"
    sha256 cellar: :any,                 ventura:       "a4958e6792c20d99b41b93dda5a081f4659585953240a31dab6515a2b5fe725c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20afbf7a5bce579a3ad2ebb078e77b4b0b9bbb66affdd3ee4e8b55e3ae437a8e"
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
