class Netcat6 < Formula
  desc "Rewrite of netcat that supports IPv6, plus other improvements"
  homepage "https://www.deepspace6.net/projects/netcat6.html"
  url "https://deb.debian.org/debian/pool/main/n/nc6/nc6_1.0.orig.tar.gz"
  sha256 "db7462839dd135ff1215911157b666df8512df6f7343a075b2f9a2ef46fe5412"
  license "GPL-2.0"

  bottle do
    rebuild 1
    sha256                               arm64_monterey: "cd438610979aceb80a4ef14b712af6976655067e84dd85743968e805714a8c60"
    sha256                               arm64_big_sur:  "233f4e4769def17cb05da043221a3bb3460b984b570cd4ebbcce7342e7ab6c05"
    sha256                               monterey:       "09e95539dd475a3a577dc7304ba02c07c98930778bac90f07ebd35b5328448fb"
    sha256                               big_sur:        "746665ead519a4bbeb2984d7d83d8ea8425441f922bb199e0328da562e870144"
    sha256                               catalina:       "fbba0de060d7d38efc84e3a098de48d127467fd8e6d90edf2ed96bc20b5e38df"
    sha256                               mojave:         "aba098730e397f84b6ed7534b41bd7f65f5f6182189d890ac93216faff2fe9b7"
    sha256                               high_sierra:    "b3fe44c42b33bc668cdaa0f05eb10a5f9b67891b1947b98abe9cad6464182835"
    sha256                               sierra:         "bdb853a9a63a03555682eae734d9d9a7725591dfd16128cf59f208968ef16ef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19b2eee0d231005d4431ed016b681cca59d381bd1c29747ef4ded584f109827a"
  end

  # Upstream appears to have stopped developing netcat6 and instead recommends
  # using OpenBSD's netcat (which supports IPv6) or Nmap's netcat replacement
  # (ncat).
  disable! date: "2022-07-31", because: :deprecated_upstream

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    out = pipe_output("#{bin}/nc6 www.google.com 80", "GET / HTTP/1.0\r\n\r\n")
    assert_equal "HTTP/1.0 200 OK", out.lines.first.chomp
  end
end
