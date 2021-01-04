class Mdbtools < Formula
  desc "Tools to facilitate the use of Microsoft Access databases"
  homepage "https://github.com/mdbtools/mdbtools/"
  url "https://github.com/mdbtools/mdbtools/archive/v0.9.1.tar.gz"
  sha256 "980c705b7b93b099c2639956b029b8b0116947a75a761a0b0e233e041b0faaa3"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6ba5e23cde1a24611de95ee581cea65cdde8cf53e619fecdba3f6a46e97b5094" => :big_sur
    sha256 "bc0ae6979a0fafede8b3c350cb9552581d8f9a8f885d7c3d015d8e1c77c0ca5d" => :arm64_big_sur
    sha256 "027976880d1dec75e95cca86a36b4699a5f10d6cd4ef1c5949a683dee628cd03" => :catalina
    sha256 "f88d6e3bfaad817421851b4284b93fc8cd695e6ccc43a299be08f615a000b67a" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gawk" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "readline"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}",
                          "--enable-sql",
                          "--enable-man"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/mdb-schema --drop-table test 2>&1", 1)

    expected_output = <<~EOS
      File not found
      Could not open file
    EOS
    assert_match expected_output, output
  end
end
