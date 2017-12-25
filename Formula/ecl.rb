class Ecl < Formula
  desc "Embeddable Common Lisp"
  homepage "https://common-lisp.net/project/ecl/"
  url "https://common-lisp.net/project/ecl/static/files/release/ecl-16.1.3.tgz"
  sha256 "76a585c616e8fa83a6b7209325a309da5bc0ca68e0658f396f49955638111254"
  revision 2

  head "https://gitlab.com/embeddable-common-lisp/ecl.git"

  bottle do
    sha256 "ae15644b1593091841bfcb305ba835be9502ac33c822bcc818c1405ff5490136" => :high_sierra
    sha256 "39f47c078a1b3c2640c6daa0e8c2d3700a739a66397bcde76b2cad52941deea4" => :sierra
    sha256 "db0466fd183bb63fd5dc764d5cefdfb0bf0fe2e667545c73a7aedce873ae1e99" => :el_capitan
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
