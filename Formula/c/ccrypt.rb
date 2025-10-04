class Ccrypt < Formula
  desc "Encrypt and decrypt files and streams"
  homepage "https://ccrypt.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ccrypt/1.11/ccrypt-1.11.tar.gz"
  sha256 "b19c47500a96ee5fbd820f704c912f6efcc42b638c0a6aa7a4e3dc0a6b51a44f"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "cebf96f7115ebb2be8b7f058e24de430aa06506c3dcfa5aaf9c0ff67d1bd780b"
    sha256 arm64_sequoia:  "030055fedb7e4f4136631b6cb57863d19dfbc34c422410ef246422471f6ee0b9"
    sha256 arm64_sonoma:   "6494f1e4ac165f00a8f1cadecc17a33175e0bc2e13d2c6111c4c0825416a43c2"
    sha256 arm64_ventura:  "8670e0da25badd930fe04316614c22caceec629bba9ae2fd4b1576f25d1c724f"
    sha256 arm64_monterey: "6df2f69dee386a1f37820245fdcf2f2f6e52389e1617b8bcd72dfae25d829207"
    sha256 arm64_big_sur:  "df71b344abdb49c98de85ee062d3e505afdcdb203cde01d165e326b52e7bb891"
    sha256 sonoma:         "86ff4e2d100a5abd9a6a96ce38ef6aa7ff85aecb65c749d71d2f86f4f7cc8824"
    sha256 ventura:        "d4f607f5cf6620bf41ff3bb79f0343f0e6a01960e419d5fe254ecf0e007440ca"
    sha256 monterey:       "77326e57d8ebf598daed98540cde9e40b67dc5f759c5ea01a48a8defec9c2347"
    sha256 big_sur:        "f416ae1ffac238640025b992cfedb05ab6894d0ef6c60742b3ab95757bd137f0"
    sha256 catalina:       "e09c7818b7de98e36d433080334e169ac970e1a020114ddab1fdbbd54135ddbc"
    sha256 arm64_linux:    "66d34366219e543be249e3763823d38d772d6569159611ea1b2f6efa1daef601"
    sha256 x86_64_linux:   "3e2c5e49110742fb547d82b661695d2044a2404869e7224c1de1be036dd253de"
  end

  conflicts_with "ccat", because: "both install `ccat` binaries"

  def install
    args = ["--mandir=#{man}", "--with-lispdir=#{elisp}"]
    args << "--disable-libcrypt" if OS.linux? # https://sourceforge.net/p/ccrypt/bugs/28/#22b5

    system "./configure", *args, *std_configure_args
    system "make", "install"
    system "make", "check"
  end

  test do
    touch "homebrew.txt"
    system bin/"ccrypt", "-e", testpath/"homebrew.txt", "-K", "secret"
    assert_path_exists testpath/"homebrew.txt.cpt"
    refute_path_exists testpath/"homebrew.txt"

    system bin/"ccrypt", "-d", testpath/"homebrew.txt.cpt", "-K", "secret"
    assert_path_exists testpath/"homebrew.txt"
    refute_path_exists testpath/"homebrew.txt.cpt"
  end
end
