class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://github.com/postgresql-interfaces/psqlodbc/archive/refs/tags/REL-18_00_0004.tar.gz"
  sha256 "af12354a5960846f5578e168b456cde3c21a11c4788277663bf9266b1de3adda"
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
    sha256 cellar: :any, arm64_golden_gate: "e4896a138635ba0c2980ef17bf3d4e87cc202938654a1e00935473cd36e70b4a"
    sha256 cellar: :any, arm64_tahoe:       "dd15910207f80da0e955216e0d42bef7330e261aae74333748cad61f4cf25003"
    sha256 cellar: :any, arm64_sequoia:     "4dfe7f2f1f9af99b6763cec4aa587546f6d1ebd1aed35a9f35f5191512c783d5"
    sha256 cellar: :any, arm64_linux:       "9a77cefdca59e44fe64c5d85a6f52ac8025ccfc815d70c6f36810cd8b20a900e"
    sha256 cellar: :any, x86_64_linux:      "5d6796b1ab7e264558806441f2628a40fd72701264c25676cbda7d7d1fe0ffa1"
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
