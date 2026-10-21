class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://github.com/postgresql-interfaces/psqlodbc/archive/refs/tags/REL-18_00_0005.tar.gz"
  sha256 "7c42d4cc5e578698d18d1655561f435dce95864bddb2e0c0e13dae3650b38698"
  license "LGPL-2.0-or-later"
  head "https://github.com/postgresql-interfaces/psqlodbc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^REL[._-]?v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2e2003ae94d692fc6d5d88e484dace1f1c53c9af942ee3658ae6d312a0094896"
    sha256 cellar: :any, arm64_tahoe:       "e2e300dca75e454193b8165610364d081a466697a5327935d4792fffbdd463f9"
    sha256 cellar: :any, arm64_sequoia:     "055ae8ee30688693b9d1ff575d89ad19fe3f888bf1fe96d47d41c4186a9c60b1"
    sha256 cellar: :any, arm64_linux:       "55b34e6c3bd17a68f72ca7d89b700b9f949ffea7ae97cc2b8247ab11379c3ecb"
    sha256 cellar: :any, x86_64_linux:      "78a41a1d4bdd11d2280d6cbf8a00e0a2374a0872bc03adae07f9588d4cc1d869"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libpq"
  depends_on "unixodbc"

  def install
    system "./bootstrap"
    system "./configure", "--prefix=#{prefix}",
                          "--with-unixodbc=#{formula_opt_prefix("unixodbc")}"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{formula_opt_bin("unixodbc")}/dltest #{lib}/psqlodbcw.so")
    assert_equal "SUCCESS: Loaded #{lib}/psqlodbcw.so\n", output
  end
end
