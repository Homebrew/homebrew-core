class Ecl < Formula
  desc "Embeddable Common Lisp"
  homepage "https://common-lisp.net/project/ecl/"
  url "https://common-lisp.net/project/ecl/files/release/16.1.2/ecl-16.1.2.tgz"
  sha256 "2d482b1a0a4fbd5d881434517032279d808cb6405e22dd91ef6d733534464b99"

  head "https://gitlab.com/embeddable-common-lisp/ecl.git"

  bottle do
    sha256 "276654f49f532011521121138b5d142fc98b7bd403ed3d7481a16884f714569b" => :el_capitan
    sha256 "b9e11c5853de9c20aed0979da6e2a63afca3ee1f2ab925d62d5d192557af62df" => :yosemite
    sha256 "f7ae77f595ab08425fb6789018f67b40461656d146a16e6add510f7418f4a8ee" => :mavericks
    sha256 "7a460060b7220667124bc09483fc5ee84e8dd63a167ce0d1aea617832621d052" => :mountain_lion
  end

  depends_on "gmp"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-unicode=yes",
                          "--enable-threads=yes",
                          "--with-system-gmp=yes"
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
