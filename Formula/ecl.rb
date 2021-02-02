class Ecl < Formula
  desc "Embeddable Common Lisp"
  homepage "https://common-lisp.net/project/ecl/"
  url "https://common-lisp.net/project/ecl/static/files/release/ecl-21.2.1.tgz"
  sha256 "b15a75dcf84b8f62e68720ccab1393f9611c078fcd3afdd639a1086cad010900"
  license "LGPL-2.1-or-later"
  head "https://gitlab.com/embeddable-common-lisp/ecl.git", branch: "develop"

  bottle do
    rebuild 2
    sha256 big_sur: "bbdf0be3bd7607484c959f54b1237f9f74020d9539ce66167cd1cd2195ca9953"
    sha256 catalina: "59311b4250de8733f88bb1a3f02e1a7e7c39f148e2e881c35d87ca7aad68c23e"
    sha256 mojave: "dbbfb2aa9172ec1d3b905da9059fef5ff524caeab42ada84220c0251a913103e"
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
