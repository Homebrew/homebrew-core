class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.10.1",
      revision: "4a89d97db8a5a23a15f3025c8d2d2885337c2637"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "646fe14caca4b1583df74fc4a0823abd23ab07744b22cda1eb06362142c16775"
    sha256 cellar: :any,                 arm64_ventura:  "e029245236b3c6b1d019bf026666ff2ec4e906c8b67dd92e0d83a9749f91b974"
    sha256 cellar: :any,                 arm64_monterey: "6086064341bd2665b449a5c95f44d4807fa87ab565dab7277b55537e10045b3d"
    sha256 cellar: :any,                 sonoma:         "408b13291b72fe123045a2b4e3de10f492e529ab52f2a07d3eac027860aebcf3"
    sha256 cellar: :any,                 ventura:        "964b743f0cf86c56a24bb169cf18e74eefc66464f6fd16f7c078a1ab262597e5"
    sha256 cellar: :any,                 monterey:       "52017e33636689b14f311b59b413141ca141ff081f1d839d49047d68df547348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33ba9b83c69fce14cc96fda85e06211dad9420d2b2661b00fd57846e8a5aaa3b"
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
