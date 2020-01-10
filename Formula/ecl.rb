class Ecl < Formula
  desc "Embeddable Common Lisp"
  homepage "https://common-lisp.net/project/ecl/"
  url "https://common-lisp.net/project/ecl/static/files/release/ecl-16.1.3.tgz"
  sha256 "76a585c616e8fa83a6b7209325a309da5bc0ca68e0658f396f49955638111254"
  revision 4
  head "https://gitlab.com/embeddable-common-lisp/ecl.git"

  bottle do
    sha256 "489b7db6f0b46b5a72de59d80806e73bdf5feb163477e31d47bfdf91e6d53ba2" => :catalina
    sha256 "a3f198cdd7ef1c869670f8c40e46846c0aa4d02702f3569688878c08dae77187" => :mojave
    sha256 "9afd54b532ae1f1ee3d62b32323007cc736def18f7dde363b19ee9cbf67364fa" => :high_sierra
    sha256 "c4a7bf602fd2ce4a265cee2944cc0aa57829f9b2d965c1c54da4a905ee8cdf41" => :sierra
    sha256 "2c27794e63438b4e4cb0aaaf8924d6586f2774c29f06b01429d569fec742e55d" => :el_capitan
  end

  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "libffi"

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}",
                          "--enable-threads=yes",
                          "--enable-boehm=system",
                          "--enable-gmp=system"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"simple.cl").write <<~EOS
      (write-line (write-to-string (+ 2 2)))
    EOS
    assert_equal "4", shell_output("#{bin}/ecl -shell #{testpath}/simple.cl").chomp
  end
end
