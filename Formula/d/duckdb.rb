class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.9.1",
      revision: "401c8061c6ece35949cac58c7770cc755710ca86"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0c05b82fba640aa6b7feba92f7a552e8b9fc778a670efd20c0c5b8130533fa93"
    sha256 cellar: :any,                 arm64_ventura:  "7727781d93bae38d75482c5af3056402f2890a4b7b395cb338830d7ad4f4913a"
    sha256 cellar: :any,                 arm64_monterey: "bccad7e915a188c5de6340d31d218aa8671ec678dbc2dee6351f833e3019fcab"
    sha256 cellar: :any,                 sonoma:         "5b8287eadff7b9e449b55b7ebe622116c4d38d5e0d18d123abcb6e309f483284"
    sha256 cellar: :any,                 ventura:        "443c540f1e6c79dd83ed435eec82883d0d0cfae66ed78bca0fed7e53c9fa0552"
    sha256 cellar: :any,                 monterey:       "b060aca1d90b40b81c22d8b8c52c040ad466574842865ee8d4d9f60213e0b783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d1ca0c71904e9b776df201f3bc4815123408b7400782014c22b03c1179f2734"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build"
    cd "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_EXTENSIONS='autocomplete;icu;parquet;json'",
             "-DCMAKE_LTO=thin", "-DENABLE_EXTENSION_AUTOLOADING=1",
             "-DENABLE_EXTENSION_AUTOINSTALL=1"
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
