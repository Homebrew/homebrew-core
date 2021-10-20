class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.3.0",
      revision: "46a0fc50aa00ac019aee2157cf3382b85993f728"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "4d285e3baaf35f18548ee40fd8ac6aa887513a3a9d34e10818ac81618ec85823"
    sha256 cellar: :any,                 big_sur:       "0e19a1b26fd5a45d487cb1d1d7446ee18a246e740c346ec9adf367cdf8420b04"
    sha256 cellar: :any,                 catalina:      "922bed5796ee9453ddf19764991edb99b7b735edb32113c8ae2da64a98367585"
    sha256 cellar: :any,                 mojave:        "3e9e19cc7e833d7565978e0859ad2e8ec8116fd74984e06e718e707d59ac36cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a1232df3b2efa016000825be8f57df8a11195c60fbc9e7fbb0a67b41fdf19cd"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build
  depends_on "utf8proc"

  def install
    ENV.deparallelize if OS.linux? # amalgamation builds take GBs of RAM
    mkdir "build/amalgamation"
    system Formula["python@3.9"].opt_bin/"python3", "scripts/amalgamation.py", "--extended"
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
