class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.2.8",
      revision: "a8fd73b37bfc249b76b2aaa488d52dfdb39bb3d9"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "2255199bcc0917c191dfd77cbcd6b8e14b484072808b5efe5cf4572f58fa3bdd"
    sha256 cellar: :any,                 big_sur:       "3e34f585159990b2cbdb1330e7932be0adcbfa9a4a97a50aec13d410338033b3"
    sha256 cellar: :any,                 catalina:      "f73b9649e3e6265c3ee089510513b1124023ce4915cd21f6fe85c5b5fe5394a1"
    sha256 cellar: :any,                 mojave:        "af8214d5a28184ca748e8c5f2284c1b0238d0c2e1a4b4fc6e5eca45e457d2644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef025d3b72bd174cec7a755b87c9040031e0c269bde2c2989565d0d15dd5e587"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  # Upstream PR to fix Linux amalgamation build: https://github.com/duckdb/duckdb/pull/2060
  # Revisit for removal on next release
  patch do
    url "https://github.com/duckdb/duckdb/commit/405c21760dbad0940aa5ea1d9c121ac4cd866ab1.patch?full_index=1"
    sha256 "184139de9cc7b696d5a0ef28f4f76ef5552f904198473f4e1ed7bdedfd93a535"
  end

  def install
    on_linux do
      ENV.deparallelize # amalgamation builds take GBs of RAM
    end
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
