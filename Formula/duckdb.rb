class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.2.8",
      revision: "a8fd73b37bfc249b76b2aaa488d52dfdb39bb3d9"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "0d7a874d4ef6c80616b6495dcd8cfd89ae092c9e5dae7ec677a4bca2a184de20"
    sha256 cellar: :any,                 big_sur:       "614f4b26481b51f9aa98c185eeca064f6df58610b6a6187c6603098de047fd34"
    sha256 cellar: :any,                 catalina:      "22786e74a4bf3212375b066d18cfa3fc507dd6699e86f7dc46a0eef102dd7c7d"
    sha256 cellar: :any,                 mojave:        "263f3d4b4815b8db217f4e17787d5304c73e742dbae51cbfd2a02b1d0ac90b36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fa7cf67a5d8884b153f9d9520770eb767453d6c0ba0b4fa2089521b74df4456"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build
  depends_on "utf8proc"

  def install
    on_linux do
      ENV.deparallelize # amalgamation builds take GBs of RAM
    end
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
