class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v1.3.0",
      revision: "71c5c07cdd295e9409c0505885033ae9eb6b5ddd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "19bfba7d3b110722048d3cd663ad0a77d80eb4d2f18909cf435db1cd25c17dd4"
    sha256 cellar: :any,                 arm64_sonoma:  "8a0d96caf3655adcc53fbf2153e219bfb2ba81ab19d31399b5f016addfaeedaf"
    sha256 cellar: :any,                 arm64_ventura: "9b756019e17326131a1652c6a1491a489a97616b1c08f4ee72456e5ad2003bfe"
    sha256 cellar: :any,                 sonoma:        "74443b6d66e5b9094a4ecbb29d1c81fed73c711753314b8fbfa00baf75250b65"
    sha256 cellar: :any,                 ventura:       "b5be86d3c40213aed75bfb84b6ec373618bd8570a25f8d428ae3b28d4e4b7472"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4e6edba3e24af826aaf67ce25fe6a7d7f1a7c8498a585aae3d114576dd00cc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1c7f3dfa1d74142faa6533a6a626264cb12841c2769175dd06388f306d1f7bf"
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
