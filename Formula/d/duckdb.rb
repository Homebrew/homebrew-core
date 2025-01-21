class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v1.1.3",
      revision: "19864453f7d0ed095256d848b46e7b8630989bac"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c0ee4c114f855cda3cedf3aa3ebc55e98d2478abd8f82afdb6c2f77b35f69a99"
    sha256 cellar: :any,                 arm64_sonoma:  "e64f1b902ef3ff598494153defca23bba62975d122bf16264421278553d775dc"
    sha256 cellar: :any,                 arm64_ventura: "06aff3e01d6a7727dc4c202df223e37d71daf63a8ba6f21d21b1a48655d1a3df"
    sha256 cellar: :any,                 sonoma:        "56920ddb8940e09ac52352b2b05dc9daa0f39dfd03fd146894754b6e425b034a"
    sha256 cellar: :any,                 ventura:       "3f0270c622867c1944df25c1b7e1085bacc4ac751b6b540ed58ac6e21d933f8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25d8fcc9c429a718e5e97d8312efd04672a9b91d5aa7b9cc1af42e2178851dc8"
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
