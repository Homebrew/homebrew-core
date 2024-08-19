class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://github.com/postgresql-interfaces/psqlodbc/archive/refs/tags/REL-16_00_0005.tar.gz"
  sha256 "1aa1bd5f9cb26ac1a4729ed2ab48974b29c335bebff6830d66aaac8bcd081ab0"
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
    sha256 cellar: :any,                 arm64_sonoma:   "7fd21b79605a85947cccc4e07c62b3faf8335bf859d8ea55315cf71ae9afaffa"
    sha256 cellar: :any,                 arm64_ventura:  "47d2a659777c84b1bf8f7f5995fc458ccc4fe51ff46b29bd23d956022521adcb"
    sha256 cellar: :any,                 arm64_monterey: "582f989ea86b281852f3254bfc3028dcc450beaad15611e227495107fa4f6807"
    sha256 cellar: :any,                 sonoma:         "0a5a3fd24ed89f95f1c3e070cd7720d4b2640b4a4a0c9b1503f30048fc554998"
    sha256 cellar: :any,                 ventura:        "6d79d640bcca27313ff4ad061bc641c9490a91d67526732de5a7306bda266334"
    sha256 cellar: :any,                 monterey:       "3f8dc7a82900b7ecf58546c3ac55d241005e751f22cf15516da74c1d835106f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "948e339558ace1ebf56a58e8f4a96a56f29776811c9a7cdbc127182a3a35a82b"
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
