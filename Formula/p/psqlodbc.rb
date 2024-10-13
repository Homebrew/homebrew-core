class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://github.com/postgresql-interfaces/psqlodbc/archive/refs/tags/REL-17_00_0002.tar.gz"
  sha256 "fc89244b4a57e325a4687a89a909934d19f17938fd5dd7f274703e74c950bed9"
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
    sha256 cellar: :any,                 arm64_sequoia: "66bdefe8888c3b21d3367b20f67f1c70df8c0010316ac962de35f526ed9c69f3"
    sha256 cellar: :any,                 arm64_sonoma:  "a15cf041cf278dc277ed9c92b6e9c4d0c6b9e51da2325d7fe6d5d0d01e932abb"
    sha256 cellar: :any,                 arm64_ventura: "1720b7a92e2b3dd220b2b774a8a9a2059bb163ae285ccf4722a4097aaacc83d8"
    sha256 cellar: :any,                 sonoma:        "e939ca501c7086b5f4e9e97b650e57c9fbbdaac67863a347397be9feda7f3899"
    sha256 cellar: :any,                 ventura:       "78b3a75149c0d3aed3b3a4e28d8163619bd04c6875d05b7496063b213414dacb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4cc06fbf46ee154170d14a3d4ae5850a731e70d8af9e58ff216a9283f249b47"
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
