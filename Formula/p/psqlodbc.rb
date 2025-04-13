class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://github.com/postgresql-interfaces/psqlodbc/archive/refs/tags/REL-17_00_0004.tar.gz"
  sha256 "6d15bc4f49a0c9e0d263ff30b042d4d49ef4ead745c2dd1f0d0d9c3d2a98b4fc"
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
    sha256 cellar: :any,                 arm64_sequoia: "9e49dfa5be7d586220140bb26762cf8c05a65dba887e3a09c1500bd7fb5b186b"
    sha256 cellar: :any,                 arm64_sonoma:  "bed65e967f687e24a56f233b8def6503ba7a6edcae118b978e429e515a466ccb"
    sha256 cellar: :any,                 arm64_ventura: "5476eb923b4ebdd7377596ee553139a6f059730b2f0e1917cea60e3bc62ecb1d"
    sha256 cellar: :any,                 sonoma:        "b34391bdbb4a636e9837e209ba178d1660de9ced2d63d033de3f57f39808ebda"
    sha256 cellar: :any,                 ventura:       "b57bbc3a6e580f83e695067836a9eff58fd033ef55b6970cb8c31672429e81b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dc7bc2a5663fa87105c9d984d80966dc28ac4e772b3abc381095bea44e53979"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15dfa1958197323d476238ea26efa630f85955c78eca68eb7b0a54a682660034"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libpq"
  depends_on "unixodbc"

  def install
    system "./bootstrap"
    system "./configure", "--prefix=#{prefix}",
                          "--with-unixodbc=#{Formula["unixodbc"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].bin}/dltest #{lib}/psqlodbcw.so")
    assert_equal "SUCCESS: Loaded #{lib}/psqlodbcw.so\n", output
  end
end
