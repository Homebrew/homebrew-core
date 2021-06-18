class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/cwida/duckdb.git",
      tag:      "v0.2.7",
      revision: "8bc050d05b25a379efdaa537bd801b712671a83b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "be1c4285a38b7224c479c8b7af840a0bd64ff6f4336aee8ab7fa9e982c733140"
    sha256 cellar: :any, big_sur:       "4848fe1c93a3e16fed76bebc2441abf08a2cc9112604a8cd4095d0de54bc3786"
    sha256 cellar: :any, catalina:      "2930a8c7cea33085291b47312d606c6c690fac65fc076d4d0cfc27eba534517e"
    sha256 cellar: :any, mojave:        "82e004232c2bf0a15c7f5d99b4f3b4a5969deaeec4414fa5566dbb8413f2ca2c"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  def install
    mkdir "build/amalgamation"
    system Formula["python@3.9"].opt_bin/"python3", "scripts/amalgamation.py"
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
