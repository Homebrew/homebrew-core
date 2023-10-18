class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.9.1",
      revision: "401c8061c6ece35949cac58c7770cc755710ca86"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "179d8717e57225098d3607306baad2342fdc023a4a3a61fc25327b887c4ac279"
    sha256 cellar: :any,                 arm64_ventura:  "18dfc4a1e2cc91357d52ace7937ea35ddc9cf2fbd9714e1df209215097902688"
    sha256 cellar: :any,                 arm64_monterey: "7c766051d957ab13294a90cc674e9bff53f60f933f7bb4e6d1186064e0126634"
    sha256 cellar: :any,                 sonoma:         "21d7b8b4f4d147849f0a3ece8164ab82943a6ea0c6d82710e597135fcd418243"
    sha256 cellar: :any,                 ventura:        "556e73ca20a8552abcd04107f04a91fc6fd2c709aaa6a52b5686bb357d672aeb"
    sha256 cellar: :any,                 monterey:       "c11c19aae255c2875cafee6fb07a7f7fbbabb9e7413b851f2495db7ab41576e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72fe93d4c9bd0335616c5f4cbf4025b8dfd6f8ab38583f22697b5e292a1edca1"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build"
    cd "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_EXTENSIONS='autocomplete;icu;parquet;json'",
             "-DENABLE_EXTENSION_AUTOLOADING=1",
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
