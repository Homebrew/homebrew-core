class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://github.com/postgresql-interfaces/psqlodbc/archive/refs/tags/REL-18_00_0002.tar.gz"
  sha256 "54c07372478d1085f4f7f98753d6454f8b231c155ff29c5aca4b34aa95bfc51f"
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
    sha256 cellar: :any, arm64_tahoe:   "2aac053918a25fbae7120aee158d59b468fed678201d5a92d7d0f66aacb25cfd"
    sha256 cellar: :any, arm64_sequoia: "775570e12994cfedbb333cffb16ad6717e9c37681b4aef44318ddb49809834f9"
    sha256 cellar: :any, arm64_sonoma:  "6eb23efb1c4ce46cbfc7055f777ae4e0ed4562181076218e826ca63e0c0fde14"
    sha256 cellar: :any, sonoma:        "18c3b760f0cf3fa2ab1d4df676998b7417a284e31d7dca14ff15084ec290d1c6"
    sha256 cellar: :any, arm64_linux:   "278530d1ef05ad8be0769c46e21da3cbcf09c22cabd5e4929a86577e7d59a17b"
    sha256 cellar: :any, x86_64_linux:  "5cf83ae262b45476a1a8c7f15197c79a26cda0dc4612eabb6bd155f6f8328761"
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
    output = shell_output("#{Formula["unixodbc"].bin}/dltest #{lib}/psqlodbcw.so")
    assert_equal "SUCCESS: Loaded #{lib}/psqlodbcw.so\n", output
  end
end
