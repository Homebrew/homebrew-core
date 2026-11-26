class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://github.com/postgresql-interfaces/psqlodbc/archive/refs/tags/REL-18_00_0007.tar.gz"
  sha256 "421215067d91152b10d3b7e251de1d02d627766e3c99ca2ed9065a7babca7a85"
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
    manifest_sha256 "d4511603c0454bc14219adedd537440fab370baefe41b73f09c91114ab8fc8e4"
    sha256 cellar: :any, arm64_golden_gate: "1ad6f9f975de0f739ac2bd1b325c8686748be9563943f14529c2f375bc9ff39e"
    sha256 cellar: :any, arm64_tahoe:       "5c06e3e2058a39c8d3b25c40e80c57b501c48fd1b69039d40d2ac1b0768bef65"
    sha256 cellar: :any, arm64_sequoia:     "c5d1ff99dec8908598c647fcc0c606787a2d8766578db73586d6eee17697b0a5"
    sha256 cellar: :any, arm64_linux:       "7c2e1cc931616a3506a256c1b986851d319b65dd6d4e2cbdfb86982ff24ccd13"
    sha256 cellar: :any, x86_64_linux:      "0aae765552bdc81fd2b0ffc683e969fefc8b1194a94180b7dd7422cffe5c78b3"
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
