class Pgcopydb < Formula
  desc "Copy a Postgres database to a target Postgres server"
  homepage "https://github.com/dimitri/pgcopydb"
  url "https://github.com/dimitri/pgcopydb/archive/refs/tags/v0.18.tar.gz"
  sha256 "d1fbc729b3d6aabbebd64f515a956130adf42a0e9104886084d76d5702fb99d0"
  license "PostgreSQL"
  head "https://github.com/dimitri/pgcopydb.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "0abe2100b8618872b68755752dc2d39a1ad730eb34e2732d6121724a2e7a844c"
    sha256 arm64_sequoia: "2434673cf48fbbab5e75f2cb7f03fb1f5b32a14c06182a5f5666ba9b1bf50234"
    sha256 arm64_sonoma:  "f7403924e8340bfa32ebf98a9862cef1f6ab7275d8c633ea847241d48a2b4e10"
    sha256 sonoma:        "e8916d9e86be6c9fc1a25e80ea8f2fc8aa309fbce5b211960c116fbb6631e3c1"
    sha256 arm64_linux:   "9827cba77982afb1555e51cdf3a5a5518b16bd84faaa3c0c88c7779ad582ee77"
    sha256 x86_64_linux:  "85445fc9a40b676e3ad961d36aeb68eecaacd74ac9e90fcd5a88078294c31de4"
  end

  depends_on "sphinx-doc" => :build
  depends_on "bdw-gc"
  depends_on "libpq"

  def install
    system "make", "bin"
    libexec.install "src/bin/pgcopydb/pgcopydb"

    (bin/"pgcopydb").write_env_script libexec/"pgcopydb", PATH: "$PATH:#{formula_opt_bin("libpq")}"

    system "make", "-C", "docs", "man"
    man1.install Dir["docs/_build/man/*"]
  end

  def caveats
    <<~EOS
      Pgcopydb searches for PostgreSQL command-line tools in your system's PATH environment variable.
      To use a specific PostgreSQL version's command-line tools, ensure they are accessible in your PATH.

      When no PostgreSQL tools are found in PATH, pgcopydb defaults to using the command-line tools provided by the libpq formula.
    EOS
  end

  test do
    assert_match 'Failed to export a snapshot on "postgresql://example.com"',
                 shell_output("#{bin}/pgcopydb clone --source postgresql://example.com " \
                              "--target postgresql://example.com 2>&1", 12)
  end
end
