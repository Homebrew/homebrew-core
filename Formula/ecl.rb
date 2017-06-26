class Ecl < Formula
  desc "Embeddable Common Lisp"
  homepage "https://common-lisp.net/project/ecl/"
  url "https://common-lisp.net/project/ecl/static/files/release/ecl-16.1.3.tgz"
  sha256 "76a585c616e8fa83a6b7209325a309da5bc0ca68e0658f396f49955638111254"
  revision 1

  head "https://gitlab.com/embeddable-common-lisp/ecl.git"

  bottle do
    sha256 "4bb2a23a3b38d5010ce0e2dd951b94e3e76803da8e52d23f719187ee844e4a56" => :sierra
    sha256 "70b2b9adbd061863c14a2122e485773c92870fa55211b773569cd4012a5f5cb8" => :el_capitan
    sha256 "f86b66f182afdc3b7a8e8e51ca3e230d6ccc308d760faae1b2b345fd1ead0ab3" => :yosemite
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
    (testpath/"simple.cl").write <<-EOS.undent
      (write-line (write-to-string (+ 2 2)))
    EOS
    assert_equal "4", shell_output("#{bin}/ecl -shell #{testpath}/simple.cl").chomp
  end
end
