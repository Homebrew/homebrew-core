class Pgcopydb < Formula
  desc "Copy a Postgres database to a target Postgres server"
  homepage "https://github.com/dimitri/pgcopydb"
  url "https://github.com/dimitri/pgcopydb/archive/refs/tags/v0.17.tar.gz"
  sha256 "7ed96f7bbc0a5250f3b73252c3a88d665df9c8101a89109cde774c3505882fdf"
  license "PostgreSQL"
  head "https://github.com/dimitri/pgcopydb.git", branch: "main"

  bottle do
    sha256 arm64_sequoia:  "19bae342e0b705bc2cf5ecd05ea8d8aff97164180f10ac444230ef9cbbca53af"
    sha256 arm64_sonoma:   "f447198169c35c932e4d5c39145592ebd6fef8c1aca559069eef866a1c82e1af"
    sha256 arm64_ventura:  "0d58547a3e5a617c0e3356e46b2f051ef9fe79a3d2ff7170d70f5557390cc080"
    sha256 arm64_monterey: "2b3135ab67d28ee63f41c1af27eda76bb328ac92d125c4d7581c7ded337d2881"
    sha256 sonoma:         "787dea9fc195e201ddf945cd1a13b0ef37d62b6fc38b13c2f1d5dd36238b3717"
    sha256 ventura:        "5cf2444bb98d637c9cfc7c0a37556a62d7c3936046bc61e5c4c78e812513eb8c"
    sha256 monterey:       "407ae43050aceb3697506809f1866ce7fd5924758075abb4f52d8500359c9756"
    sha256 x86_64_linux:   "f921320ad1318ec78e25e99f5a15f7392ab47f9f834f0b23fa029b989847d9aa"
  end

  depends_on "sphinx-doc" => :build
  depends_on "bdw-gc"
  depends_on "libpq"

  def install
    system "make", "bin"
    libexec.install "src/bin/pgcopydb/pgcopydb"

    (bin/"pgcopydb").write_env_script libexec/"pgcopydb", PATH: "#{Formula["libpq"].opt_bin}:$PATH"

    system "make", "-C", "docs", "man"
    man1.install Dir["docs/_build/man/*"]
  end

  test do
    assert_match 'Failed to export a snapshot on "postgresql://example.com"',
                 shell_output("#{bin}/pgcopydb clone --source postgresql://example.com " \
                              "--target postgresql://example.com 2>&1", 12)
  end
end
