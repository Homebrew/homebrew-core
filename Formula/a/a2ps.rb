class A2ps < Formula
  desc "Any-to-PostScript filter"
  homepage "https://www.gnu.org/software/a2ps/"
  url "https://ftpmirror.gnu.org/gnu/a2ps/a2ps-4.15.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/a2ps/a2ps-4.15.8.tar.gz"
  sha256 "8d13915a36ebbfa8e7b236b350cc81adc714acb217a18e8d8c60747c0ad353f9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "f6895a00c5e039d81af9950d1e22c6012e50d6b8c19b5ad576953d06194ffc41"
    sha256 arm64_sequoia: "2a959e7d521d6fd47fb598017109de310a72d25939dad660f24083b033155b13"
    sha256 arm64_sonoma:  "a28d04c14c4444bd70fb99801cf541e167508e39720136ad8085b8cc33132f6a"
    sha256 sonoma:        "1460a22fe6091322739e60676866cca20541f9c6789a1c698468e702f3e99789"
    sha256 arm64_linux:   "72508d993a610ed1bf5a8f8c59e381265c6d2ef3327f68d68319c6dd536e4032"
    sha256 x86_64_linux:  "f683fec596b5cfeb6d64503ca3a776969de98ee6b44b4a551a05db5e4ff4e230"
  end

  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "libpaper"

  def install
    system "./configure", "--sysconfdir=#{etc}",
                          "--with-lispdir=#{elisp}",
                          "--with-packager=#{tap.user}",
                          "--with-packager-version=#{pkg_version}",
                          "--with-packager-bug-reports=#{tap.issues_url}",
                          *std_configure_args
    system "make"
    # Avoid overwriting existing a2ps.cfg
    system "make", "install", "sysconfdir=#{prefix}/etc"
    inreplace prefix/"etc/a2ps.cfg", prefix, opt_prefix
    etc.install (prefix/"etc").children
  end

  test do
    (testpath/"test.txt").write("Hello World!\n")
    system bin/"a2ps", "test.txt", "-o", "test.ps"
    assert_match "(Hello World!) p n\n", File.read("test.ps")
  end
end
