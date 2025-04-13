class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v1.2.2",
      revision: "7c039464e452ddc3330e2691d3fa6d305521d09b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "37e16cc9346d3ecb9914e19f29d74bfc6125efa1b3fc0572c8f94dda7c6b6979"
    sha256 cellar: :any,                 arm64_sonoma:  "9f8e1d732831361bba9a986d98eafbf2d440705229eb8a7ab313b88d98f0bbe6"
    sha256 cellar: :any,                 arm64_ventura: "6841e7a1b8edb2d821de678400b373900e02942df1e3f667ed7474ed980d3b6f"
    sha256 cellar: :any,                 sonoma:        "2f6b583cebc3b938aafb44aa23bf405c293010650eb1d0d22a1f42a8c134755c"
    sha256 cellar: :any,                 ventura:       "316378b7ec3d6a6763318cc66f716443ee9ecc63ff1459363d02f5bc45e30c9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d79ef342c28786bd8f5dbf9562bc51a1ca960f4f4a8932b3bc6bfd2510c8996a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91cca7c442bf9f6bde58b3cbe14575fd3caf350dc093f4c86e6322dafd09aaad"
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
