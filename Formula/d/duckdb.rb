class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v1.0.0",
      revision: "1f98600c2cf8722a6d2f2d805bb4af5e701319fc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dc780d44c83bb66f2d2cea0d846dd23ccf63b97e8ea88541ae4ff0e55b1a9782"
    sha256 cellar: :any,                 arm64_ventura:  "46abde811b7710d4e948c3fb985e93df68172b52b70228ad0da7fc78dd238e97"
    sha256 cellar: :any,                 arm64_monterey: "bf80e0fec54a0855d51820cf4a3bed33c8ebdb0bb13d1fbf1b4dbf51c2aa9d37"
    sha256 cellar: :any,                 sonoma:         "b5047193fa43ce0279e9e9345def87f70de4696b2d038967ca36447cdd6be75c"
    sha256 cellar: :any,                 ventura:        "e85dd901b4585bf0e5fab4e12a4d8f81a38f062867b1b1a76023edc2eda4f5fb"
    sha256 cellar: :any,                 monterey:       "6eef05d4f018e9224171832f253049aa50ef8c90e21d7d04c357684c3c6ae1ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce19b677837eeab74cfa2d0f241888c28720cb6753b72af9a4ad4c3a7e064d65"
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
