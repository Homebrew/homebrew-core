class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.16.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.16.tar.gz"
  sha256 "a034af5f02c7376da7dd3251bbc23f01001b22556450aaffe61e2bcab1b60fef"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "eb8d93c06b4a0daec501faec524709226724cc277c11382b44d384200a7e9a94"
    sha256 arm64_monterey: "b6a4e9be8be9e17a3a78d96c7db57f5c29c5a4f90ffa50b582b08b6213a335db"
    sha256 arm64_big_sur:  "d32dcc7635d4faf6e1809ea0e8e1ab0891ca757c3624a304b1929fb32398fc16"
    sha256 ventura:        "26edcf456dce024acba59596a0bf8dcf8d8f1f36ab00834fdc2cec9ee710b31a"
    sha256 monterey:       "903eaf1a202efc86e24e0eb6f24d82dc7e086ffa364a8f1cf168718dbdd5d437"
    sha256 big_sur:        "fa354242b181bdc405664fe12c89c5ad11a5c789bf3adfcd83e08a8797d7b2fb"
    sha256 x86_64_linux:   "860144077d9630d568beb1402a2a65287ab122e27017ed3a6b2493da4962cce1"
  end

  depends_on "gnutls"
  depends_on "gsasl"
  depends_on "libtool"
  depends_on "readline"

  uses_from_macos "libxcrypt"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # This is hardcoded to be owned by `root`, but we have no privileges on installation.
    inreplace buildpath.glob("dotlock/Makefile.*") do |s|
      s.gsub! "chown root:mail", "true"
      s.gsub! "chmod 2755", "chmod 755"
    end

    system "./configure", "--disable-mh",
                          "--prefix=#{prefix}",
                          "--without-fribidi",
                          "--without-gdbm",
                          "--without-guile",
                          "--without-tokyocabinet"
    system "make", "install"
  end

  test do
    system "#{bin}/movemail", "--version"
  end
end
