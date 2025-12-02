class Pgcopydb < Formula
  desc "Copy a Postgres database to a target Postgres server"
  homepage "https://github.com/dimitri/pgcopydb"
  url "https://github.com/dimitri/pgcopydb/archive/refs/tags/v0.17.tar.gz"
  sha256 "7ed96f7bbc0a5250f3b73252c3a88d665df9c8101a89109cde774c3505882fdf"
  license "PostgreSQL"
  head "https://github.com/dimitri/pgcopydb.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "0922fc7e2a6d606e02d8e140e9d621bb9b865cb9c9ba074a057d132cb1b3b187"
    sha256 arm64_sequoia: "f0f0c6e9e3ebe35b9d32a1e127cafe4fe120356dc758a1475c6830af13d048b2"
    sha256 arm64_sonoma:  "ff96b14430ae0b5ccea29365fb3d3b4d37a792534d74744250ebaaf425a6851d"
    sha256 arm64_ventura: "b1fbef60821224b0230fae583caaebf0b70750d0dd7d8ec0a9ec2ec7cb0eb8bd"
    sha256 sonoma:        "a3e2806d74af8c705b2077032255a7cd39ac079c4997c980231b49651416c109"
    sha256 ventura:       "daefeb247366553b851071c3d429869d26695d11b4a675f7e51245039301b3f2"
    sha256 arm64_linux:   "c92d7b713b5620eee463b7c5a355c9c9d04676cc3d7d5e1bbf298d3bc0c4bd0d"
    sha256 x86_64_linux:  "6f99b95987e4d9873cb365c5be588e3b55281ccf09e2879f67d63dd97cf8370e"
  end

  depends_on "sphinx-doc" => :build
  depends_on "bdw-gc"
  depends_on "libpq"

  def install
    system "make", "bin"
    libexec.install "src/bin/pgcopydb/pgcopydb"

    (bin/"pgcopydb").write_env_script libexec/"pgcopydb", PATH: "$PATH:#{Formula["libpq"].opt_bin}"

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
