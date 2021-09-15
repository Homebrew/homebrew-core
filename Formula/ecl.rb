class Ecl < Formula
  desc "Embeddable Common Lisp"
  homepage "https://common-lisp.net/project/ecl/"
  url "https://common-lisp.net/project/ecl/static/files/release/ecl-21.2.1.tgz"
  sha256 "b15a75dcf84b8f62e68720ccab1393f9611c078fcd3afdd639a1086cad010900"
  license "LGPL-2.1-or-later"
  head "https://gitlab.com/embeddable-common-lisp/ecl.git", branch: "develop"

  bottle do
    sha256 arm64_big_sur: "847322265172ae8fe032c0a0ce7aa49a97fc5d7b65b67747b75e328567938d08"
    sha256 big_sur:       "5df2258cb07a0f70a7e5d664f691d843fd5cae916009dbbc1ee0f6867c3dff48"
    sha256 catalina:      "5286a86476c459ce1694d50363a885be2869df62bf632c532755eb51fe9fdbc5"
    sha256 mojave:        "db02128ab8feb220552e2dad2f565283c44b64b688e2e467ecfbe68e4dce6bef"
    sha256 x86_64_linux:  "b6b04526fb3118e8a87cbebbd0201a8aeefed7c085ce588d87b7a0ea2e88dce8"
  end

  depends_on "texinfo" => :build # Apple's is too old
  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "libffi"

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}",
                          "--enable-threads=yes",
                          "--enable-boehm=system",
                          "--enable-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}",
                          "--with-libffi-prefix=#{Formula["libffi"].opt_prefix}",
                          "--with-libgc-prefix=#{Formula["bdw-gc"].opt_prefix}"
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
