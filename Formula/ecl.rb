class Ecl < Formula
  desc "Embeddable Common Lisp"
  homepage "https://common-lisp.net/project/ecl/"
  url "https://common-lisp.net/project/ecl/static/files/release/ecl-16.1.2.tgz"
  sha256 "2d482b1a0a4fbd5d881434517032279d808cb6405e22dd91ef6d733534464b99"

  head "https://gitlab.com/embeddable-common-lisp/ecl.git"

  bottle do
    sha256 "3ff5a197a14d03d9e8c5083289506439f473685db7fe15b27f2659652c8165b9" => :sierra
    sha256 "8915d3c5862aa5b89beb28119778715308f6639abde6fcefe052f716c3db9560" => :el_capitan
    sha256 "46647c3577257ff30197afe689161d36a8bd8e99a2b24eaa44f97f2f38e644b1" => :yosemite
    sha256 "5fa6a6a6f0ac717897ed635484a4b1675a48b8455e6178990bbce5109353131d" => :mavericks
  end

  depends_on "gmp"

  def install
    system "./configure", "--prefix=#{prefix}",
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
