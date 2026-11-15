class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://github.com/postgresql-interfaces/psqlodbc/archive/refs/tags/REL-18_00_0006.tar.gz"
  sha256 "0c2e2367a133125ca1f10ccc5534252d05163a28bf4d4b1badf8ba3ef2dca320"
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
    sha256 cellar: :any, arm64_golden_gate: "fece1f6474f830cc8386c870ad47894712be7671573f98b666432209f4ad44dd"
    sha256 cellar: :any, arm64_tahoe:       "c93cfa9c51f821153842ba4f62784e7375066c1b4b54d9996174032d371f238c"
    sha256 cellar: :any, arm64_sequoia:     "724663aa6a0fd1d347fe43e93cf82644f29e633891f5c0d0815e4461b3097a84"
    sha256 cellar: :any, arm64_linux:       "b4d7d471c3b171e940307330dae730dfb4acaa26d7cd0782dac728afd81bc390"
    sha256 cellar: :any, x86_64_linux:      "b6704a85257c11f16dc958f6c8254dd50e9b8ce0b949f93d708c5b14b07f7373"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libpq"
  depends_on "unixodbc"

  deny_network_access!

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
