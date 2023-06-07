class Ccrypt < Formula
  desc "Encrypt and decrypt files and streams"
  homepage "https://ccrypt.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ccrypt/1.11/ccrypt-1.11.tar.gz"
  sha256 "b19c47500a96ee5fbd820f704c912f6efcc42b638c0a6aa7a4e3dc0a6b51a44f"
  license "GPL-2.0"

  bottle do
    sha256 arm64_ventura:  "8670e0da25badd930fe04316614c22caceec629bba9ae2fd4b1576f25d1c724f"
    sha256 arm64_monterey: "6df2f69dee386a1f37820245fdcf2f2f6e52389e1617b8bcd72dfae25d829207"
    sha256 arm64_big_sur:  "df71b344abdb49c98de85ee062d3e505afdcdb203cde01d165e326b52e7bb891"
    sha256 ventura:        "d4f607f5cf6620bf41ff3bb79f0343f0e6a01960e419d5fe254ecf0e007440ca"
    sha256 monterey:       "77326e57d8ebf598daed98540cde9e40b67dc5f759c5ea01a48a8defec9c2347"
    sha256 big_sur:        "f416ae1ffac238640025b992cfedb05ab6894d0ef6c60742b3ab95757bd137f0"
    sha256 catalina:       "e09c7818b7de98e36d433080334e169ac970e1a020114ddab1fdbbd54135ddbc"
    sha256 mojave:         "49054d9d502ab13e65ab873cc9d355ab75438372a7770c38c4c7c35c84c31e3a"
    sha256 high_sierra:    "a4d270d5b5f467870f0b265f6f2d1861762d853df46756a34ac7e6a6d83e2121"
    sha256 sierra:         "048295cb4f95c9f0f3c5f1a619141e08c0326b6d8252c62c97608fb028cb48f7"
    sha256 el_capitan:     "a98ea0f3dbee5e9086bea342ac8291303970b1d8a85344be2b4d91330a919ae9"
    sha256 x86_64_linux:   "3e2c5e49110742fb547d82b661695d2044a2404869e7224c1de1be036dd253de"
  end

  conflicts_with "ccat", because: "both install `ccat` binaries"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-lispdir=#{share}/emacs/site-lisp/ccrypt"
    system "make", "install"
    system "make", "check"
  end

  test do
    touch "homebrew.txt"
    system bin/"ccrypt", "-e", testpath/"homebrew.txt", "-K", "secret"
    assert_predicate testpath/"homebrew.txt.cpt", :exist?
    refute_predicate testpath/"homebrew.txt", :exist?

    system bin/"ccrypt", "-d", testpath/"homebrew.txt.cpt", "-K", "secret"
    assert_predicate testpath/"homebrew.txt", :exist?
    refute_predicate testpath/"homebrew.txt.cpt", :exist?
  end
end
