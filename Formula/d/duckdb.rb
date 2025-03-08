class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v1.2.1",
      revision: "8e52ec43959ab363643d63cb78ee214577111da4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ec3a38cd6619f40094000b8909d750aefce1c7febe0ba36930afdb06443d40e4"
    sha256 cellar: :any,                 arm64_sonoma:  "4e615647853552fd0a1a83fdc9ac8fc34aa23b93aca03e65e8728e8452a16e44"
    sha256 cellar: :any,                 arm64_ventura: "fe20e4975270dcfe1b1fb74f72fea79e150ea12d6085ce6080545bad1e809d18"
    sha256 cellar: :any,                 sonoma:        "c1d72d5dac16fc63e0d2be312ebd1fd823674bbf829da504c49a940787b58b22"
    sha256 cellar: :any,                 ventura:       "39c4f6445e5be3aeba669f09e91f401d47f3dfc84ae58e8ad3f6a3e04de12433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4abb6faabed1b88073c1243902a9e61349268cc4bf79326e284bc9432c443be"
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
