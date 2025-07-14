class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v1.3.2",
      revision: "0b83e5d2f68bc02dfefde74b846bd039f078affa"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2061ae10a4cd05587b37fec9a7abf721763b7ce20f15744505e86745740ed140"
    sha256 cellar: :any,                 arm64_sonoma:  "be2964118af95274b2bbebe613ba22fdf48dbd82b8a01e6f824e840eeed0904d"
    sha256 cellar: :any,                 arm64_ventura: "e9154de3fa792c47c77544e63d338dee9a967856463fca7fee9f21a050fdb1f3"
    sha256 cellar: :any,                 sonoma:        "314f8f1abd862fb47ce2284dd845281a41e1b01a0cfe9d6c5a8f4a23b9debec1"
    sha256 cellar: :any,                 ventura:       "c1b6b728de521d1969de1d64d27f02036bb8d221ba8ed4199fe6c96623af41e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bb8a13d4919cc496fd219a6b1c8de0d4718d3d58296fb83c5684e6423d2438d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "797a43be18afd83479b4d97589b68a32307da540de046cf5edb675c328266b5d"
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
