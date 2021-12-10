class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.3.1",
      revision: "88aa81c6b1b851c538145e6431ea766a6e0ef435"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d62b4d92c3161fdbc03bd72ea5353d15d2e7ce7d457240fb1a7ef18e53957f19"
    sha256 cellar: :any,                 arm64_big_sur:  "0edcf2ae659f36d918cdf3a070b198ec0ec0c2208b0dfe9338bf1aea72ab2c73"
    sha256 cellar: :any,                 monterey:       "f5351c2f7c5198483042f3acc94f38324138e9d65e48589d584c916144bfc9c9"
    sha256 cellar: :any,                 big_sur:        "b17d562d33b1f735cff89f08cefb1158aeaf0e42487aee0a691966653fabdbb1"
    sha256 cellar: :any,                 catalina:       "7109176d3717de319efd7eb4a5b74d282ad593d3325bf36932bedef20b11ddfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45ab4e1bbf1d1b744b80e2726a7ae9c32f59fc412e00d197293cae56430cbb95"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build
  depends_on "utf8proc"

  def install
    ENV.deparallelize if OS.linux? # amalgamation builds take GBs of RAM
    mkdir "build/amalgamation"
    system Formula["python@3.10"].opt_bin/"python3", "scripts/amalgamation.py", "--extended"
    cd "build/amalgamation" do
      system "cmake", "../..", *std_cmake_args, "-DAMALGAMATION_BUILD=ON"
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
      ┌───────────┐
      │ avg(temp) │
      ├───────────┤
      │ 45.0      │
      └───────────┘
    EOS

    assert_equal expected_output, shell_output("#{bin}/duckdb_cli < #{path}")
  end
end
