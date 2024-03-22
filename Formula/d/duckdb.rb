class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.10.1",
      revision: "4a89d97db8a5a23a15f3025c8d2d2885337c2637"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "825f73aea5ffaf61e125bcd8180a706d712d0577578706b19fdc20f528979a3a"
    sha256 cellar: :any,                 arm64_ventura:  "144c60147341b4c5d84226ab7946f10b9b0047eca6a61a35eedb1d6a2da94179"
    sha256 cellar: :any,                 arm64_monterey: "b2b0a23fba24c6f2a66ee6ff117c664ef006fb650026961ae01043b2984945a6"
    sha256 cellar: :any,                 sonoma:         "efd30f76771d15bc94f654b6c338e8c302dd8287b7c531bc376087267f96811a"
    sha256 cellar: :any,                 ventura:        "150dfcfc6ebdeb54b0036538e181db0c113149a09c598536c1679c26ca12cb51"
    sha256 cellar: :any,                 monterey:       "6da7e844ceeaceb5deb61d2de2bf9b6b16fd688f1d7d53856089abf14d6a2ebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eeafe8bd37364ecaae03afe78fab87433697263046c278f84d506cabc4da639e"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

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
