class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://github.com/postgresql-interfaces/psqlodbc/archive/refs/tags/REL-17_00_0006.tar.gz"
  sha256 "1c886c5303a43fae3b7bdc4f674aaf3927813e937c310716b6f83fd61434f44c"
  license "LGPL-2.0-or-later"
  head "https://github.com/postgresql-interfaces/psqlodbc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^REL[._-]?v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9aa0e50a32cd06602fd8ca3c9e9a7e7be2dd43f43fa7baa287a8f2fb33d35b67"
    sha256 cellar: :any,                 arm64_sonoma:  "fdd9914597028be6afe45103c0502f97027850d3c28587bdaa71eca7ec77b6ca"
    sha256 cellar: :any,                 arm64_ventura: "416058e5349573dd91929c36507e2c6b4bf26ba06a7e61b902626e27276991b5"
    sha256 cellar: :any,                 sonoma:        "866ba671fda96d5abdd7ea6d897403485829310ff629cb18ea68251e2686b222"
    sha256 cellar: :any,                 ventura:       "e8fc788ff3819c7f5b46982baf695d586e50c9046b5970ad11c418c0b9431bd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a2a492bfca18421c0df06dbb1154b6432878c9689a79bf0497f051fe1278ab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4e915e1ad71414c65162bc86332943510b8899d03c2c21a1795a67d42308a80"
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
