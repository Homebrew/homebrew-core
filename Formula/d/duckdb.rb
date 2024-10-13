class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v1.1.1",
      revision: "af39bd0dcf66876e09ac2a7c3baa28fe1b301151"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "30c6b2ac5c241b0b1fe39579c11618a156c6d928e5c10fda69f2ab07e8beddae"
    sha256 cellar: :any,                 arm64_sonoma:  "dc4ecc85cc5ab2bacf0e5b3c3ee14377a40b26b23cdbc635313201a31ed057fd"
    sha256 cellar: :any,                 arm64_ventura: "e1cc02a152cc4cb5b0b85f782b16d5f7342cc7bf6f56abbba053d5918712e624"
    sha256 cellar: :any,                 sonoma:        "2f7ae580bac30ab7c16476fa08fdeb45fe1a5ef4cf21992ee1c610d8bbec21b4"
    sha256 cellar: :any,                 ventura:       "16c1fa85d5b1133a182b675c238ea96ec30f18dbf449da1210b2f8078f6d1ac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d69f3969ba4b3ef5a0f5347b5c2adb37fdacf9f3276971b9de13a4d0559deaf"
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
